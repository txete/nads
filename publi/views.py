from django.http import HttpResponse
from django.shortcuts import render
from django.db.models import Avg, Sum, F
from django.db import connection
import json

from .models import Movie, Genre, Ad
# AdGenre

# def home(request):
#     return HttpResponse("Hello, Django!")

def Get_Genres():
    genres = Genre.objects.all()
    return genres

# def Set_Ad(ad):
#     ad = Ad(ad_description=ad["description"],ad_budget=ad["budget"],ad_is_active=True,aprox_rating=ad["satisfaction"])
#     ad.save()

def Get_Movies():
    movies = Movie.objects.all()
    return movies

def home(request):
    if(request.method == "POST"):
        with connection.cursor() as cursor:
            query = """
            CALL netflix.insert_ad(
                %s::character varying,
                %s::real,
                %s::boolean,
                %s::smallint,
                %s::integer[]
            )
            """

            x = request.POST
            params = [
                str(x["description"]),            
                float(x["budget"]),               
                True,                             
                int(x["satisfaction"]),           
                x.getlist('genres')
            ]

            cursor.execute(query, params)

    return render(
        request,
        'index.html',
        {
            'genres': Get_Genres()
        }
    )

def stats(request):
    # Anotamos cada género con la calificación promedio y el total de reproducciones de sus películas
    genres = Genre.objects.annotate(
        avg_rating=Avg('movie__avg_rating'),
        total_plays=Sum('movie__plays')
    )

    # Serializamos la data
    serialized_data = json.dumps([{
        'genre': genre.genre,
        'avg_rating': genre.avg_rating,
        'total_plays': genre.total_plays
    } for genre in genres])

    return render(request, 'stats.html', {'serialized_data': serialized_data})

COST_PER_VIEW = 0.02

def adsManage(request): 
    ads = Ad.objects.annotate(
        total_views=Sum('genre__movie__plays'),
        remaining_budget=F('ad_budget') - (Sum('genre__movie__plays') * 0.02)
    ).prefetch_related('genre')

    context = {
        'ads': ads
    }
    
    return render(request, 'ads.html', context)
