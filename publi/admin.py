from django.contrib import admin

# Register your models here.

from .models import Genre, Movie, Ad, Playlist, Rating, Viewer

class MovieAdmin(admin.ModelAdmin):
    list_display = ('title','avg_rating','plays')
admin.site.register(Movie,MovieAdmin)

class AdAdmin(admin.ModelAdmin):
    list_display = ('ad_description','ad_budget','ad_is_active')
admin.site.register(Ad,AdAdmin)

# class AdGenreAdmin(admin.ModelAdmin):
#     list_display = ('ad_id','genre_id')
# admin.site.register(AdGenre,AdGenreAdmin)

# class MovieGenreAdmin(admin.ModelAdmin):
#     list_display = ('movie_id','genre_id')
# admin.site.register(MovieGenre,MovieGenreAdmin)

class PlaylistAdmin(admin.ModelAdmin):
    list_display = ('viewer_id','playlist_name')
admin.site.register(Playlist,PlaylistAdmin)

# class PlaylistMoviesAdmin(admin.ModelAdmin):
#     list_display = ('playlist_id','movie_id')
# admin.site.register(PlaylistMovies,PlaylistMoviesAdmin)

class RatingAdmin(admin.ModelAdmin):
    list_display = ('viewer_id','movie_id','rating')
admin.site.register(Rating,RatingAdmin)

class ViewerAdmin(admin.ModelAdmin):
    list_display = ('username','password')
admin.site.register(Viewer,ViewerAdmin)

class GenreAdmin(admin.ModelAdmin):
    list_display = ('genre_id','genre')
admin.site.register(Genre,GenreAdmin)
