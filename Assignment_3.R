# Create a demo R dataframe
demo_df <- data.frame(
    ID = 1:5,
    Name = c("Alice", "Bob", "Charlie", "David", "Eve"),
    Age = c(23, 35, 29, 42, 31),
    Score = c(88.5, 92.0, 76.5, 85.0, 90.5)
)

print(demo_df)
library(ggplot2)

ggplot(demo_df, aes(x = Name, y = Score, fill = Age)) +
    geom_bar(stat = "identity") +
    labs(title = "Scores by Name and Age", x = "Name", y = "Score") +
    theme_minimal()

