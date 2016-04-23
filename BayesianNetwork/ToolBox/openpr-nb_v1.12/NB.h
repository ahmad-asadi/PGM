/********************************************************************
* Naive Bayes Classifier V1.12
* Implemented by Rui Xia (rxia@nlpr.ia.ac.cn)
* Last updated on 2010-10-19. 
*********************************************************************/

#pragma once

#include <iostream>
#include <fstream>
#include <iomanip>
#include <string>
#include <vector>
#include <set>
#include <map>
#include <algorithm>
#include <math.h>

# define VERSION       "V1.12"
# define VERSION_DATE  "2010-10-19"

using namespace std;

struct sparse_feat
{
    vector<int> id_vec;
    vector<int> value_vec;
};

class NB 
{
protected:
    vector<sparse_feat> samp_feat_vec;
    vector<int> samp_class_vec;
    int feat_set_size;
    int class_set_size;
    vector<float> class_prb;
    vector< vector<float> > feat_class_prb;
     
public:
    NB();
    ~NB();
    void save_model(string model_file);
    void load_model(string model_file);
    void load_training_data(string training_file);
    void learn(int event_model);
    vector<float> predict_logp_bernoulli(sparse_feat samp_feat);
    vector<float> predict_logp_multinomial(sparse_feat samp_feat);
    vector<float> score_to_prb(vector<float> &score);
    int score_to_class(vector<float> &score);
    float classify_test_data(string test_file, string output_file, int event_model, int output_format);

protected:
    vector<string> string_split(string terms_str, string spliting_tag);
    void read_samp_file(string samp_file, vector<sparse_feat> &samp_feat_vec, vector<int> &samp_class_vec);
    float calc_acc(vector<int> &true_class_vec, vector<int> &pred_class_vec);
    void calc_class_prb();
    void calc_feat_class_prb_bernoulli();
    void calc_feat_class_prb_multinomial();

};


