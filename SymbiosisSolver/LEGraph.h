#include <iostream>
#include <vector>
#include <string>
#include <map>
#include <string>

#include "Operations.h"

using namespace std;

class Graph;
class Edge;
class Vertex;

class EdgeLabel {
	string threadName;
	set<string> holdLocks;
	pair<Operation*, Operation*> events;

public:
	EdgeLabel(string name, set<string> hs, pair<Operation*, Operation*> es) {
		threadName = name;
		holdLocks = hs;
		events = es;
	}

	string getName() {return threadName;}
	set<string> getH() {return holdLocks;}
	pair<Operation*, Operation*> getEvents() {return events;}

	void print() {
		std::cerr << "label: " << threadName << "\n";
		std::cerr << "hostLocks: " << "\n";
		for (set<string>::iterator it = holdLocks.begin(); 
					it != holdLocks.end(); ++it) {
			std::cerr << *it << " ";	
		}
		std::cerr << "\n";
		events.first->print(), events.second->print();
	}
};

class Edge {
	EdgeLabel* weight;
	Vertex * vertex1;
	Vertex * vertex2;

	public:
	EdgeLabel* getWeight() const {return weight;}
	Vertex* getV1() const {return vertex1;}
	Vertex* getV2() const {return vertex2;}
	void setWeight(EdgeLabel* w){weight=w;}
	void setV1(Vertex * v){vertex1=v;}
	void setV2(Vertex * v){vertex2=v;}
	Edge(EdgeLabel* w, Vertex* v1, Vertex* v2){weight=w;vertex1=v1;vertex2=v2;}
};

class Vertex {
	string label;
	//Operation* op;
	vector<Edge *> edgesLeavingMe;
	bool visited;

	public:
	string getLabel() const {return label;}

	vector<Edge*> getEdges()const{return edgesLeavingMe;}

	Edge * getEdgeTo(string d){
		for (vector<Edge *>::iterator it = edgesLeavingMe.begin(); it != edgesLeavingMe.end(); ++it){
			if ((*it)->getV2()->getLabel()==d){
				return (*it);
			}
		}
		return 0;
	}
	void setVisited(bool v){visited=v;}
	bool getVisited() {return visited;}
	void addEdge(Edge * e){edgesLeavingMe.push_back(e);}
	void removeEdge(Edge * e){
		edgesLeavingMe.erase(remove(edgesLeavingMe.begin(),edgesLeavingMe.end(),e),edgesLeavingMe.end());
	}

	void removeEdgeTo(string l){
		Edge * e = getEdgeTo(l);
		removeEdge(e);
	}

	Vertex(string l){label=l; visited=false;}
};

class LEGraph {
	vector<Edge*> edges;
	map<string, Vertex*> vertices;

	vector<Vertex*> traceV;
	vector<Edge*> traceE;

	vector<vector<Edge*> > cycles;

	public:
	Vertex *  addVertex(string label){
		if (vertices.find(label) != vertices.end())
		  return vertices[label];

		Vertex*	v = new Vertex(label);
		vertices[label]=v;
		return v;
	}
	map<string, Vertex*> getVertices(){return vertices;}
	vector<Edge*> getEdges(){return edges;}

	Edge * addEdge(EdgeLabel* w, string from, string to){

		if (vertices.find(from) != vertices.end() && vertices.find(to) != vertices.end()){
			Vertex * vfrom = vertices.find(from)->second;
			Vertex * vto = vertices.find(to)->second;
			Edge * e = new Edge(w,vfrom,vto);
			vfrom->addEdge(e);
			edges.push_back(e);
			return e;
		} else{
			//handle case where vertcies did not exist.
			return 0;
		}
	}

	Edge * getEdge(string from, string to){
		if (vertices.find(from) != vertices.end() && vertices.find(to) != vertices.end()){
			Vertex * v1 = vertices.find(from)->second;
			Vertex* v2 = vertices.find(to)->second;
			Edge * e = (*v1).getEdgeTo(to);
			return e;
		}
		else {
			return 0;
		}
	}


	void removeEdge(string from, string to){
		Edge * e = getEdge(from,to);
		if (e != 0){
			edges.erase(remove(edges.begin(),edges.end(),e),edges.end());
			(*e).getV1()->removeEdge(e);
		}
	}

	Vertex * getVertexWithLabel(string l){
		if (vertices.find(l) != vertices.end())
		  return vertices.find(l)->second;
		else
		  return 0;
	}

	void removeVertex(string l){
		Vertex * v = getVertexWithLabel(l);
		if (v != 0){
			vector<Edge *> edges = getVertexWithLabel(l)->getEdges();

			for (vector<Edge *>::iterator it = edges.begin(); it != edges.end(); ++it){
				string from = (*it)->getV1()->getLabel();
				string to = (*it)->getV2()->getLabel();
				removeEdge(from,to);
			}
			vertices.erase(l);
		}
		else {
			//handle case where vertex did not exist.
		}
	}

	vector<Vertex *> whereCanIGo(Vertex * v)
	{
		vector<Vertex *> destinations;
		vector<Edge *> edges = v->getEdges();
		for (vector<Edge *>::const_iterator it = edges.begin(); it != edges.end(); ++it) {
			if ((*it)->getV2() !=v) {
				destinations.push_back((*it)->getV2());
			}
		}      
		destinations.push_back(v);
		return destinations;
	}

	bool isCyclicUtil(Vertex* v, map<string, bool> &visited, map<string, bool> recStack){
		visited[v->getLabel()]=true;
		recStack[v->getLabel()]=true;
		vector<Edge *> edges = v->getEdges(); 
		for(size_t i=0; i<edges.size(); ++i){
			//int nbr = adj[v][i];
			Vertex* nbr = edges[i]->getV2();
			if(!visited[nbr->getLabel()]){
				//cout << "path: " << v << "----->" << nbr << endl;    
				if(isCyclicUtil(nbr, visited, recStack))
				  return true;
			} else if(recStack[nbr->getLabel()]){
				//cout << "path: " << v << "----->" << nbr << endl;    
				//cout << "back edge: " << v << "----->" << nbr << endl;
				return true;
			}
		}
		return false;
	}

	bool isCyclic(){
		map<string, bool> visited;//(V, false);
		map<string, bool> recStack;//(V, false);
		for (map<string, Vertex*>::iterator it = vertices.begin();
					it != vertices.end(); it++) {
			if(!visited[it->first] && isCyclicUtil(it->second, visited, recStack))
			  return true;
		}
		return false;
	}

	void findCycles(Vertex* v) {
		if (v->getVisited() == 1) {
			if (traceV.size() == 1)
				return ;

			std::cerr << "Cycle: " << traceV.size() << " " << traceE.size() << "\n";
			/*for (vector<Vertex*>::iterator it = traceV.begin();
						it != traceV.end(); ++it) {
				Vertex* v = *it;
				std::cerr << v->getLabel() << " ";
			}
			std::cerr << "\n";

			for (vector<Edge*>::iterator it = traceE.begin();
						it != traceE.end(); ++it) {
				Edge* e = *it;
				std::cerr << "Edge: " << e->getV1()->getLabel() << " " << e->getV2()->getLabel() << " \n";
				e->getWeight()->print();
			}*/

			if (traceE.size() != 0)
				cycles.push_back(traceE);

			return ;
		}

		v->setVisited(true);
		traceV.push_back(v);
		vector<Edge*> edges = v->getEdges();
		for (vector<Edge*>::iterator it = edges.begin();
					it != edges.end(); ++it) {
			Edge* e = *it;
			traceE.push_back(e);
			findCycles(e->getV2());
		}
		traceV.erase(traceV.end()-1);
		if (traceE.size() != 0)
		  traceE.erase(traceE.end()-1);
	}

	vector<vector<Edge*> > getCycles() {
		return cycles;
	}

};


template <class T> 
void printGraph(T * t){

	map<string,Vertex*> vertices = t->getVertices();

	std::cerr << "Print Graph:\n";
	for (map<string, Vertex*>::iterator it = vertices.begin(); it != vertices.end(); ++it){
		cout << it->first <<": ";
		vector<Edge *> edges = it->second->getEdges();
		for (vector<Edge *>::iterator jit = edges.begin(); jit != edges.end(); ++jit){
			string l1 = (*jit)->getV1()->getLabel();
			string l2=(*jit)->getV2()->getLabel();
			if (l1 != it->first){cout << l1 << ", ";}
			if (l2 != it->first){cout << l2 << ", ";}
		}
		cout << endl;
	}
}

template <class T> 
bool isPath(T * t, string from, string to)
{
	Vertex * vfrom = t->getVertexWithLabel(from);
	Vertex * vto = t->getVertexWithLabel(to);

	if (vfrom == 0 || vto == 0) {
		return false;
	}

	if (from==to) {
		return true;
	}


	T g = *t;

	map<string, Vertex*> vertices = t->getVertices();
	vector<Edge *> edges = t->getEdges();

	vector<Vertex *> verticesToCheck;
	verticesToCheck.push_back(vfrom);
	vertices.erase(from);

	while (verticesToCheck.size() != 0){
		vector<Vertex *> destinations = t->whereCanIGo(verticesToCheck[0]);
		verticesToCheck.erase(verticesToCheck.begin());


		for (vector<Vertex *>::const_iterator it = destinations.begin(); it != destinations.end(); ++it) {
			//
			if (vertices.find((*it)->getLabel()) != vertices.end()) {
				if ((*it)->getLabel()==to) {
					return true;
				}
				verticesToCheck.push_back((*it));
				vertices.erase((*it)->getLabel());
			}
		}
	}
	return false;
}
