#include <bits/stdc++.h>
#include <fstream>
using namespace std;
ofstream fout;
ifstream fin;
int total = 0;
int miss = 0;
struct node
{
    int valid = 0;
    int tag = 0;
    int index = 0;
    int offset = 0;
};

int compareNode(node node1, node node2)
{
    if (node1.tag == node2.tag)
        return 1;
    else
        return 0;
}

int pow2(int n)
{
    int c = 0;
    while (n != 1)
    {
        n /= 2;
        c++;
    }
    return c;
}

void direct(int cache_size, int block_size, char *argv[])
{
    int buffer;
    fstream fin, fout;
    fin.open(argv[1], ios::in);
    fout.open(argv[2], ios::out);
    fin >> buffer;
    fin >> buffer;
    fin >> buffer;
    fin >> buffer;
    int block_number = cache_size / block_size;
    int wordAddress;
    // unsigned long int byteAddress;
    node map[block_number];
    // cout << pow2(block_number) << endl;
    while (fin >> wordAddress)
    {
        total++;
        node newNode;
        newNode.valid = 1;
        newNode.tag = (wordAddress >> pow2(block_size)) / (block_number);
        newNode.index = (wordAddress >> pow2(block_size)) % (block_number);

        if (map[newNode.index].valid == 0) // miss
        {
            miss++;
            fout << "-1" << endl;
            map[newNode.index] = newNode;
        }
        else
        {
            int compareCase = compareNode(map[newNode.index], newNode);
            if (compareCase == 0) // miss
            {
                miss++;
                int victim = map[newNode.index].tag;
                fout << victim << endl;
                map[newNode.index] = newNode;
            }
            else // 0  hit
            {
                fout << "-1" << endl;
                map[newNode.index] = newNode;
            }
        }
    }
    fout << "Miss rate = " << fixed << setprecision(6) << (float)miss / (float)total << endl;
}

void fourway_LRU(int cache_size, int block_size, char *argv[])
{
    int buffer;
    fstream fin, fout;
    fin.open(argv[1], ios::in);
    fout.open(argv[2], ios::out);
    fin >> buffer;
    fin >> buffer;
    fin >> buffer;
    fin >> buffer;
    int block_number = cache_size / block_size / 4;
    int wordAddress;
    list<node> *map = new list<node>[block_number];
    while (fin >> wordAddress)
    {
        total++;
        node newNode;
        newNode.valid = 1;
        newNode.tag = (wordAddress >> pow2(block_size)) / (block_number);
        newNode.index = (wordAddress >> pow2(block_size)) % (block_number);

        list<node>::iterator it;
        for (it = map[newNode.index].begin(); it != map[newNode.index].end(); it++)
        {
            if (it->tag == newNode.tag)
                break;
        }

        if (it != map[newNode.index].end()) // hit
        {
            fout << "-1" << endl;
            map[newNode.index].erase(it);
            map[newNode.index].push_back(newNode);
        }
        else
        {
            miss++;
            if (map[newNode.index].size() < 4) // miss
            {
                fout << "-1" << endl;
                map[newNode.index].push_back(newNode);
            }
            else // miss
            {
                fout << map[newNode.index].front().tag << endl;
                map[newNode.index].pop_front();
                map[newNode.index].push_back(newNode);
            }
        }
    }
    fout << "Miss rate = " << fixed << setprecision(6) << (float)miss / (float)total << endl;
}

void fourway_FIFO(int cache_size, int block_size, char *argv[])
{
    int buffer;
    fstream fin, fout;
    fin.open(argv[1], ios::in);
    fout.open(argv[2], ios::out);
    fin >> buffer;
    fin >> buffer;
    fin >> buffer;
    fin >> buffer;
    int block_number = cache_size / block_size / 4;
    int wordAddress;
    list<node> *map = new list<node>[block_number];
    while (fin >> wordAddress)
    {
        total++;
        node newNode;
        newNode.valid = 1;
        newNode.tag = (wordAddress >> pow2(block_size)) / (block_number);
        newNode.index = (wordAddress >> pow2(block_size)) % (block_number);

        list<node>::iterator it;
        for (it = map[newNode.index].begin(); it != map[newNode.index].end(); it++)
        {
            if (it->tag == newNode.tag)
                break;
        }

        if (it != map[newNode.index].end()) // hit
        {
            fout << "-1" << endl;
            // map[newNode.index].erase(it);
            // map[newNode.index].push_back(newNode);
            // map[newNode.index].push_front(newNode);
        }
        else
        {
            miss++;
            if (map[newNode.index].size() < 4) // miss
            {
                fout << "-1" << endl;
                map[newNode.index].push_back(newNode);
            }
            else // miss
            {
                fout << map[newNode.index].front().tag << endl;
                map[newNode.index].pop_front();
                map[newNode.index].push_back(newNode);
            }
        }
    }
    fout << "Miss rate = " << fixed << setprecision(6) << (float)miss / (float)total << endl;
}

void fully_LRU(int cache_size, int block_size, char *argv[])
{
    int buffer;
    fstream fin, fout;
    fin.open(argv[1], ios::in);
    fout.open(argv[2], ios::out);
    fin >> buffer;
    fin >> buffer;
    fin >> buffer;
    fin >> buffer;
    int blocks = cache_size / block_size;
    int wordAddress;
    list<node> map;
    while (fin >> wordAddress)
    {
        total++;
        node newNode;
        newNode.valid = 1;
        newNode.tag = (wordAddress >> pow2(block_size));

        list<node>::iterator it;
        for (it = map.begin(); it != map.end(); it++)
        {
            if (it->tag == newNode.tag)
            {
                // cout << it->tag << " " << newNode.tag << endl;
                break;
            }
        }

        if (it != map.end()) // hit
        {
            fout << "-1" << endl;
            map.erase(it);
            map.push_back(newNode);
        }
        else
        {
            miss++;
            if (map.size() < blocks) // miss
            {
                fout << "-1" << endl;
                map.push_back(newNode);
            }
            else // miss
            {
                fout << map.front().tag << endl;
                map.pop_front();
                map.push_back(newNode);
            }
        }
    }
    fout << "Miss rate = " << fixed << setprecision(6) << (float)miss / (float)total << endl;
}

void fully_FIFO(int cache_size, int block_size, char *argv[])
{
    int buffer;
    fstream fin, fout;
    fin.open(argv[1], ios::in);
    fout.open(argv[2], ios::out);
    fin >> buffer;
    fin >> buffer;
    fin >> buffer;
    fin >> buffer;
    int blocks = cache_size / block_size;
    int wordAddress;
    list<node> map;
    while (fin >> wordAddress)
    {
        total++;
        node newNode;
        newNode.valid = 1;
        newNode.tag = (wordAddress >> pow2(block_size));

        list<node>::iterator it;
        for (it = map.begin(); it != map.end(); it++)
        {
            if (it->tag == newNode.tag)
            {
                // cout << it->tag << " " << newNode.tag << endl;
                break;
            }
        }

        if (it != map.end()) // hit
        {
            fout << "-1" << endl;
            // map.erase(it);
            // map.push_back(newNode);
        }
        else
        {
            miss++;
            if (map.size() < blocks) // miss
            {
                fout << "-1" << endl;
                map.push_back(newNode);
            }
            else // miss
            {
                fout << map.front().tag << endl;
                map.pop_front();
                map.push_back(newNode);
            }
        }
    }
    fout << "Miss rate = " << fixed << setprecision(6) << (float)miss / (float)total << endl;
}

int main(int argc, char *argv[])
{
    fstream fin, fout;
    int cache_size;
    int block_size;
    int asso;
    int select;
    fin.open(argv[1], ios::in);
    fout.open(argv[2], ios::out);
    // cout << pow2(16) << endl;
    // fully_LRU(512, 4);
    // fourway_LRU(256, 8);
    // direct(262144, 4);
    fin >> cache_size >> block_size >> asso >> select;

    switch (asso)
    {
    case 0:
        if (select == 0)
            direct(cache_size, block_size, argv);
        else if (select == 1)
            direct(cache_size, block_size, argv);
        break;

    case 1:
        if (select == 0)
            fourway_FIFO(cache_size, block_size, argv);
        else if (select == 1)
            fourway_LRU(cache_size, block_size, argv);
        break;

    case 2:
        if (select == 0)
            fully_FIFO(cache_size, block_size, argv);
        else if (select == 1)
            fully_LRU(cache_size, block_size, argv);
        break;

    default:
        break;
    }
    // cout << "Miss rate = "<< fixed << setprecision(6) << (float)miss / (float)total << endl;
    return 0;
}