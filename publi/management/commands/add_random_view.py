from django.core.management.base import BaseCommand
from publi.models import Movie
import random

class Command(BaseCommand):
    help = 'Add a random view to a movie'

    def handle(self, *args, **kwargs):
        movie = random.choice(Movie.objects.all())
        movie.plays += 1
        movie.save()
        self.stdout.write(self.style.SUCCESS(f'Added 1 view to movie: {movie.title}'))
