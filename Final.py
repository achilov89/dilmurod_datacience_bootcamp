import pandas as pd
from plotnine import *
import statsmodels.formula.api as smf
from scipy import stats as st
import numpy as np
from sklearn.cluster import KMeans
from sklearn.neighbors import KNeighborsClassifier
import random
from sklearn.model_selection import train_test_split


#Overview of data
grads_url='https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv'

grads_data = pd.read_csv(grads_url)


(
ggplot(grads_data, aes('Median')) + 
geom_histogram(fill = "cornflowerblue",
                 color = "white") +
labs(title = "Combined College Major Categories vs Median Income")
)

category_totals = grads_data.groupby("Major_category")["Total"].sum().sort_values()
category_totals.plot(kind="barh", fontsize=12)


#Check for corellation Median income and unemployment rate
grads_data.plot(x="Median", y="Unemployment_rate", kind="scatter")


(
    ggplot(grads_data) +
    geom_point(aes(x = 'Unemployment_rate', 
                   y='Median'), 
               color='blue') + 
    geom_smooth(aes(x = 
                    'Unemployment_rate',
                    y = 'Median'),
                method='lm'
    ) +
    labs(
        title ='Unemployment rate versus median annual income ',
        x = 'Unemployment rate',
        y = 'Median Income',
    )
    )


#Check for corellation Low wage jobs and non college jobs

grads_data.plot(x="Low_wage_jobs", y="Non_college_jobs", kind="scatter")



(
    ggplot(grads_data) +
    geom_point(aes(x = 'Low_wage_jobs', 
                   y='Non_college_jobs'), 
               color='green') + 
    geom_smooth(aes(x = 
                    'Low_wage_jobs',
                    y = 'Non_college_jobs'),
                method='lm'
    ) +
    labs(
        title ='correlation of non-college jobs with low-wage jobs',
        x = 'low-wage jobs',
        y = 'Non-college jobs',
    )
    )


# Running the OLS estimation


grads_data['unemployment_percent']=grads_data['Unemployment_rate']*100

est = smf.ols(formula='Median ~ unemployment_percent', data=grads_data).fit() 

est.summary()

(
    ggplot(grads_data) +
    geom_point(aes(x = 'unemployment_percent', 
                   y='Median'), 
               color='blue') + 
    geom_smooth(aes(x = 
                    'unemployment_percent',
                    y = 'Median'), 
                method='lm'
    ) 
    )

# K-Means Clustering
kmeans = KMeans(n_clusters=4)

kmeans_model = kmeans.fit(grads_data[['Median','Unemployment_rate']])

grads_data['cluster'] = kmeans_model.predict(grads_data[['Median','Unemployment_rate']])

# Plot Clusters

(
    ggplot(grads_data) +
    geom_point(aes(x = 'Unemployment_rate', 
                   y='Median', 
                   color='cluster')) + 
    labs(
        title ='Share of Women Majoring by Median Income of Major',
        x = 'Share of Women in Major',
        y = 'Median Income',
    ) 
    )


#Unemployment rate higher than 10% was taken as a High unemployment rate by major

grads_data['High_unemployment_rate'] = np.where(grads_data['Unemployment_rate']>0.1, 1, 0)

x = grads_data[{'Median'}]

y = grads_data['High_unemployment_rate']

# Run KNN

x_training, x_test, y_training, y_test = train_test_split(x, y, test_size = 0.3)

knn = KNeighborsClassifier(n_neighbors=4)

knn.fit(x_training, y_training)

# Predictions

predictions = knn.predict(x_test)

# Compare 

test_predictions = pd.DataFrame({'predictions': predictions, 'actuals': y_test}, 
                                columns=['predictions', 'actuals'])

# Confusion Matrix 

pd.crosstab(test_predictions['actuals'], 
            test_predictions['predictions'], 
            rownames=['Actual'], 
            colnames=['Predicted'])  

precision= 26/(26+12) #TP/(TP+FP)


recall= 26/(26+13) #TP/(TP+FN) 



f1=2*((precision*recall)/(precision+recall))

f1= 0.6698


