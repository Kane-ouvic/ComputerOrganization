#include <bits/stdc++.h>
using namespace std;

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
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

int pow2(int n)
{
    return (int)pow(2, n);
}

void fully_LRU(int cache_size, int block_size)
{
    int blocks = cache_size / block_size;
    int wordAddress;
    list<node> map;
    //cout << block_number << endl;
    while (1)
    {
        cin >> wordAddress;
        node newNode;
        newNode.valid = 1;
        newNode.tag = (wordAddress >> (2));
        //newNode.index = (wordAddress >> (3)) % (block_number);

        list<node>::iterator it;
        // find(map[newNode.index].begin(), map[newNode.index].end(), newNode.tag)
        for (it = map.begin(); it != map.end(); it++)
        {
            if (it->tag == newNode.tag)
            {
                // cout << it->tag << " " << newNode.tag << endl;
                break;
            }
        }

        if (it != map.end())
        {
            cout << "-1" << endl;
            map.erase(it);
            // cout << "debug-----------------------" << endl;
            map.push_back(newNode);
            // for (it = map[newNode.index].begin(); it != map[newNode.index].end(); it++)
            // {
            //     cout << "test: " << it->tag << endl;
            // }
        }
        else
        {
            if (map.size() < blocks)
            {
                cout << "-1" << endl;
                map.push_back(newNode);
            }
            else
            {
                cout << map.front().tag << endl;
                map.pop_front();
                map.push_back(newNode);
            }
        }

    }
}

void fourway_LRU(int cache_size, int block_size)
{
    int block_number = cache_size / block_size / 4;
    int wordAddress;
    list<node> *map = new list<node>[block_number];
    cout << block_number << endl;
    while (1)
    {
        cin >> wordAddress;
        node newNode;
        newNode.valid = 1;
        newNode.tag = (wordAddress >> (3)) / (block_number);
        newNode.index = (wordAddress >> (3)) % (block_number);

        list<node>::iterator it;
        // find(map[newNode.index].begin(), map[newNode.index].end(), newNode.tag)
        for (it = map[newNode.index].begin(); it != map[newNode.index].end(); it++)
        {
            if (it->tag == newNode.tag)
            {
                // cout << it->tag << " " << newNode.tag << endl;
                break;
            }
        }

        if (it != map[newNode.index].end())
        {
            cout << "-1" << endl;
            map[newNode.index].erase(it);
            // cout << "debug-----------------------" << endl;
            map[newNode.index].push_back(newNode);
            // for (it = map[newNode.index].begin(); it != map[newNode.index].end(); it++)
            // {
            //     cout << "test: " << it->tag << endl;
            // }
        }
        else
        {
            if (map[newNode.index].size() < 4)
            {
                cout << "-1" << endl;
                map[newNode.index].push_back(newNode);
            }
            else
            {
                cout << map[newNode.index].front().tag << endl;
                map[newNode.index].pop_front();
                map[newNode.index].push_back(newNode);
            }
        }

    }
}

void direct(int cache_size, int block_size)
{
    int block_number = cache_size / block_size;
    int wordAddress;
    // unsigned long int byteAddress;
    node map[block_number];
    cout << pow2(block_number) << endl;
    while (1)
    {
        cin >> wordAddress;
        // byteAddress = wordAddress * 4;
        node newNode;
        newNode.valid = 1;
        newNode.tag = (wordAddress >> (block_size / 2)) / (block_number);
        newNode.index = (wordAddress >> (block_size / 2)) % (block_number);
        // cout << "valid: " << newNode.valid << endl;
        // cout << "tag: " << newNode.tag << endl;
        // cout << "index: " << newNode.index << endl;

        if (map[newNode.index].valid == 0)
        {
            cout << "-1" << endl;
            map[newNode.index] = newNode;
        }
        else
        {
            int compareCase = compareNode(map[newNode.index], newNode);
            if (compareCase == 0) //
            {
                int victim = map[newNode.index].tag;
                cout << victim << endl;
                map[newNode.index] = newNode;
            }
            else // 0  hit
            {
                cout << "-1" << endl;
                map[newNode.index] = newNode;
            }
        }
    }
    // node test;
    // cout << map[0].valid << endl;
    // cout << map[0].tag << endl;
    // cout << map[0].index << endl;
    // cout << map[0].offset << endl;
}

// int fourway()
// {
// }

// int fully()
// {
// }

int main()
{
    int cache_size;
    int block_size;
    int asso;
    int select;
    // cout << pow2(16) << endl;
    fully_LRU(512, 4);
    //fourway_LRU(256, 8);
    // direct(262144, 4);
    return 0;
}