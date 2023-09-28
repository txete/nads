# Generated by Django 4.2.5 on 2023-09-27 14:07

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('publi', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Ad',
            fields=[
                ('id_ad', models.AutoField(primary_key=True, serialize=False)),
                ('ad_description', models.CharField()),
                ('ad_budget', models.FloatField()),
                ('ad_is_active', models.BooleanField()),
                ('aprox_rating', models.SmallIntegerField(blank=True, null=True)),
            ],
            options={
                'db_table': 'ad',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Genre',
            fields=[
                ('id_genre', models.AutoField(primary_key=True, serialize=False)),
                ('genre', models.CharField(unique=True)),
            ],
            options={
                'db_table': 'genre',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Movie',
            fields=[
                ('id_movie', models.AutoField(primary_key=True, serialize=False)),
                ('title', models.CharField()),
                ('description', models.CharField(blank=True, null=True)),
                ('avg_rating', models.SmallIntegerField(blank=True, null=True)),
                ('plays', models.IntegerField(blank=True, null=True)),
            ],
            options={
                'db_table': 'movie',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Playlist',
            fields=[
                ('id_playlist', models.AutoField(primary_key=True, serialize=False)),
                ('playlist_name', models.CharField(blank=True, null=True)),
            ],
            options={
                'db_table': 'playlist',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('id_user', models.AutoField(primary_key=True, serialize=False)),
                ('username', models.CharField(unique=True)),
                ('password', models.CharField()),
            ],
            options={
                'db_table': 'user',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='AdGenre',
            fields=[
                ('id_ad', models.OneToOneField(db_column='id_ad', on_delete=django.db.models.deletion.DO_NOTHING, primary_key=True, serialize=False, to='publi.ad')),
            ],
            options={
                'db_table': 'ad_genre',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='MovieGenre',
            fields=[
                ('id_movie', models.OneToOneField(db_column='id_movie', on_delete=django.db.models.deletion.DO_NOTHING, primary_key=True, serialize=False, to='publi.movie')),
            ],
            options={
                'db_table': 'movie_genre',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='PlaylistMovies',
            fields=[
                ('id_movie', models.OneToOneField(db_column='id_movie', on_delete=django.db.models.deletion.DO_NOTHING, primary_key=True, serialize=False, to='publi.movie')),
            ],
            options={
                'db_table': 'playlist_movies',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Rating',
            fields=[
                ('id_user', models.OneToOneField(db_column='id_user', on_delete=django.db.models.deletion.DO_NOTHING, primary_key=True, serialize=False, to='publi.viewer')),
                ('rating', models.BooleanField(blank=True, null=True)),
            ],
            options={
                'db_table': 'rating',
                'managed': False,
            },
        ),
    ]
