#include <bits/stdc++.h>
using namespace std;
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

void direct(int cache_size, int block_size)
{
    int block_number = cache_size / block_size;
    int wordAddress;
    // unsigned long int byteAddress;
    node map[block_number];
    //cout << pow2(block_number) << endl;
    while (cin >> wordAddress)
    {
        total++;
        node newNode;
        newNode.valid = 1;
        newNode.tag = (wordAddress >> pow2(block_size)) / (block_number);
        newNode.index = (wordAddress >> pow2(block_size)) % (block_number);

        if (map[newNode.index].valid == 0) //miss
        {
            miss++;
            cout << "-1" << endl;
            map[newNode.index] = newNode;
        }
        else
        {
            int compareCase = compareNode(map[newNode.index], newNode);
            if (compareCase == 0) //miss
            {
                miss++;
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
}

void fourway_LRU(int cache_size, int block_size)
{
    int block_number = cache_size / block_size / 4;
    int wordAddress;
    list<node> *map = new list<node>[block_number];
    while (cin >> wordAddress)
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

        if (it != map[newNode.index].end()) //hit
        {
            cout << "-1" << endl; 
            map[newNode.index].erase(it);
            map[newNode.index].push_back(newNode);
        }
        else
        {
            miss++;
            if (map[newNode.index].size() < 4) //miss
            {
                cout << "-1" << endl;
                map[newNode.index].push_back(newNode);
            }
            else //miss
            {
                cout << map[newNode.index].front().tag << endl;
                map[newNode.index].pop_front();
                map[newNode.index].push_back(newNode);
            }
        }
    }
}

void fourway_FIFO(int cache_size, int block_size)
{
    int block_number = cache_size / block_size / 4;
    int wordAddress;
    list<node> *map = new list<node>[block_number];
    while (cin >> wordAddress)
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

        if (it != map[newNode.index].end()) //hit
        {
            cout << "-1" << endl;
            // map[newNode.index].erase(it);
            // map[newNode.index].push_back(newNode);
            // map[newNode.index].push_front(newNode);
        }
        else
        {
            miss++;
            if (map[newNode.index].size() < 4) //miss
            {
                cout << "-1" << endl;
                map[newNode.index].push_back(newNode);
            }
            else //miss
            {
                cout << map[newNode.index].front().tag << endl;
                map[newNode.index].pop_front();
                map[newNode.index].push_back(newNode);
            }
        }
    }
}

void fully_LRU(int cache_size, int block_size)
{
    int blocks = cache_size / block_size;
    int wordAddress;
    list<node> map;
    while (cin >> wordAddress)
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

        if (it != map.end()) //hit
        {
            cout << "-1" << endl;
            map.erase(it);
            map.push_back(newNode);
        }
        else
        {
            miss++;
            if (map.size() < blocks) //miss
            {
                cout << "-1" << endl;
                map.push_back(newNode);
            }
            else //miss
            {
                cout << map.front().tag << endl;
                map.pop_front();
                map.push_back(newNode);
            }
        }
    }
}

void fully_FIFO(int cache_size, int block_size)
{
    int blocks = cache_size / block_size;
    int wordAddress;
    list<node> map;
    while (cin >> wordAddress)
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

        if (it != map.end()) //hit
        {
            cout << "-1" << endl;
            // map.erase(it);
            // map.push_back(newNode);
        }
        else
        {
            miss++;
            if (map.size() < blocks) //miss
            {
                cout << "-1" << endl;
                map.push_back(newNode);
            }
            else //miss
            {
                cout << map.front().tag << endl;
                map.pop_front();
                map.push_back(newNode);
            }
        }
    }
}

int main()
{
    int cache_size;
    int block_size;
    int asso;
    int select;
    // cout << pow2(16) << endl;
    // fully_LRU(512, 4);
    // fourway_LRU(256, 8);
    // direct(262144, 4);
    cin >> cache_size >> block_size >> asso >> select;

    switch (asso)
    {
    case 0:
        if (select == 0)
            direct(cache_size, block_size);
        else if (select == 1)
            direct(cache_size, block_size);
        break;

    case 1:
        if (select == 0)
            fourway_FIFO(cache_size, block_size);
        else if (select == 1)
            fourway_LRU(cache_size, block_size);
        break;

    case 2:
        if (select == 0)
            fully_FIFO(cache_size, block_size);
        else if (select == 1)
            fully_LRU(cache_size, block_size);
        break;

    default:
        break;
    }
    printf("Miss rate = %.6f\n" ,(float)miss / (float)total);
    return 0;
}