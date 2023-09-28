# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models

class Genre(models.Model):
    genre_id = models.AutoField(primary_key=True)
    genre = models.CharField(unique=True)
    
    class Meta:
        managed = False
        db_table = 'genre'


class Ad(models.Model):
    ad_id = models.AutoField(primary_key=True)
    ad_description = models.CharField()
    ad_budget = models.FloatField()
    ad_is_active = models.BooleanField()
    aprox_rating = models.SmallIntegerField(blank=True, null=True)
    genre = models.ManyToManyField(Genre)

    class Meta:
        managed = False
        db_table = 'ad'


# class AdGenre(models.Model):
#     ad = models.OneToOneField(Ad, models.DO_NOTHING, primary_key=True)  # The composite primary key (ad_id, genre_id) found, that is not supported. The first column is selected.
#     genre = models.ForeignKey('Genre', models.DO_NOTHING)

#     class Meta:
#         managed = False
#         db_table = 'ad_genre'
#         unique_together = (('ad', 'genre'),)


class Movie(models.Model):
    movie_id = models.AutoField(primary_key=True)
    title = models.CharField()
    description = models.CharField(blank=True, null=True)
    avg_rating = models.SmallIntegerField(blank=True, null=True)
    plays = models.IntegerField(blank=True, null=True)
    genre = models.ManyToManyField(Genre)

    class Meta:
        managed = False
        db_table = 'movie'


# class MovieGenre(models.Model):
#     movie = models.OneToOneField(Movie, models.DO_NOTHING, primary_key=True)  # The composite primary key (movie_id, genre_id) found, that is not supported. The first column is selected.
#     genre = models.ForeignKey(Genre, models.DO_NOTHING)

#     class Meta:
#         managed = False
#         db_table = 'movie_genre'
#         unique_together = (('movie', 'genre'),)


class Playlist(models.Model):
    playlist_id = models.AutoField(primary_key=True)
    viewer = models.ForeignKey('Viewer', models.DO_NOTHING)
    playlist_name = models.CharField(blank=True, null=True)
    movie = models.ManyToManyField(Movie)

    class Meta:
        managed = False
        db_table = 'playlist'


# class PlaylistMovies(models.Model):
#     playlist = models.ForeignKey(Playlist, models.DO_NOTHING)
#     movie = models.OneToOneField(Movie, models.DO_NOTHING, primary_key=True)  # The composite primary key (movie_id, playlist_id) found, that is not supported. The first column is selected.

#     class Meta:
#         managed = False
#         db_table = 'playlist_movies'
#         unique_together = (('movie', 'playlist'),)

class Viewer(models.Model):
    viewer_id = models.AutoField(primary_key=True)
    username = models.CharField(unique=True)
    password = models.CharField()

    class Meta:
        managed = False
        db_table = 'viewer'

class Rating(models.Model):
    viewer = models.ForeignKey(Viewer, models.DO_NOTHING)  # The composite primary key (viewer_id, movie_id) found, that is not supported. The first column is selected.
    movie = models.ForeignKey(Movie, models.DO_NOTHING)
    rating = models.BooleanField(blank=True, null=True)
    rating_id = models.AutoField(primary_key=True)

    class Meta:
        managed = False
        db_table = 'rating'
        unique_together = (('viewer', 'movie'),)
