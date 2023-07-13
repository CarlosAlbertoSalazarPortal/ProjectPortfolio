# Carlos Salazar Project 3 Movie's Lover Club

# Data Structure
movies = {
    'Mary': {
        'Big': {'Watched': 1, 'Rating': 'G'},
        'Superman': {'Watched': 3, 'Rating': 'PG'},
        'Forrest Gump': {'Watched': 3, 'Rating': 'PG-13'}
    },
    'Frank': {
        'Beauty and the Beast': {'Watched': 1, 'Rating': 'G'},
        'Kung Fu Panda': {'Watched': 5, 'Rating': 'G'},
        'Cinderella': {'Watched': 1, 'Rating': 'G'}
    }
}
# Entry for the Main Menu

while True:
    print("Welcome to the Movie Lover's Club")
    print("1. Display all members")
    print("2. Display all movie information for a member")
    print("3. Increment the times a specific movie was watched by a member")
    print("4. Add a movie for a member")
    print("5. Add a new member")
    print("Q. Quit")
    selection = input("Please enter a selection: ")


# Entry For Selections of different options

    if selection == '1':
        print("Club Members")
        print("===================")
        for member in movies:
            print(member)

    elif selection == '2':
        member_name = input("Please enter the user's name: ")
        if member_name in movies:
            print(f"Movies for club member: {member_name}")
            print("Movie\t\t\t\tRating\tWatched")
            print("="*40)
            for movie, info in movies[member_name].items():
                print(f"{movie}\t\t\t{info['Rating']}\t{info['Watched']}")
        else:
            print("Sorry, member not found")

    elif selection == '3':
        member_name = input("Please enter the member's name: ")
        if member_name in movies:
            movie_name = input("Please enter the name of the movie: ")
            if movie_name in movies[member_name]:
                movies[member_name][movie_name]['Watched'] += 1
                print("Times watched incremented")
            else:
                print("Sorry, movie title not found")
        else:
            print("Sorry, member not found")

    elif selection == '4':
        member_name = input("Please enter the member's name: ")
        if member_name in movies:
            movie_name = input("Enter movie name: ")
            if movie_name in movies[member_name]:
                print("Sorry that movie already exists")
            else:
                times_watched = int(input("Enter times watched: "))
                rating = input("Enter rating: ")
                movies[member_name][movie_name] = {'Watched': times_watched, 'Rating': rating}
                print("Movie added")
        else:
            print("Sorry, member not found")

    elif selection == '5':
        new_member = input("Enter the new member's name: ")
        if new_member in movies:
            print("Sorry, member already exists")
        else:
            movies[new_member] = {}
            print("Member added")

    elif selection.lower() == 'q':
        print('Thanks for using the Movie Lovers Club application')

# Invalid Selection
    else:
        print("Invalid selection. Please try again.")
