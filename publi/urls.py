from django.urls import path
from publi import views

urlpatterns = [
    path("", views.home, name="home"),
    path("stats", views.stats, name="stats"),  
    path("ads", views.adsManage, name="ads"),
]