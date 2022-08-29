# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cmariot <cmariot@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/09/30 11:15:47 by cmariot           #+#    #+#              #
#    Updated: 2022/08/29 19:27:28 by cmariot          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


# **************************************************************************** #
#                              EXECUTABLE'S NAME                               #
# **************************************************************************** #


NAME			 = ft_containers



# **************************************************************************** #
#                                 COMPILATION                                  #
# **************************************************************************** #


CC				 = c++


CFLAGS			 = -Wall -Wextra -Werror -std=c++98 -pthread -g3
LFLAGS			 = -Wall -Wextra -Werror -std=c++98 -pthread -g3


INCLUDES		 = -I containers
INCLUDES		+= -I unit_tests
INCLUDES		+= -I unit_tests/framework/includes


LIBRARY			 = -L unit_tests/framework -lunit



# **************************************************************************** #
#                                SOURCE FILES                                  #
# **************************************************************************** #


SRC_ROOTDIR		= unit_tests/


SRC_SUBDIR	    = $(MAIN) \
				  $(addprefix vector/, $(VECTORS)) \
				  $(addprefix stack/, $(STACK)) \
				  $(addprefix map/, $(MAP)) \


MAIN			= main.cpp


VECTORS			= 00_vector_launcher.cpp \
				  01_constructor_tests.cpp \
				  02_destructor_tests.cpp \
				  03_operator_equal_tests.cpp \
				  04_iterators.cpp \
				  05_size.cpp \
				  06_max_size.cpp \
				  07_resize.cpp \
				  08_capacity.cpp \
				  09_empty.cpp \
				  10_reserve.cpp \
				  11_operators.cpp \
				  12_at.cpp \
				  13_front.cpp \
				  14_back.cpp \
				  15_assign.cpp \
				  16_push_back.cpp \
				  17_pop_back.cpp \
				  18_insert.cpp \
				  19_erase.cpp \
				  20_swap.cpp \
				  21_clear.cpp \
				  22_allocator.cpp \
				  23_relational.cpp \
				  24_swap.cpp



STACK			= 00_map_launcher.cpp \
				  01_constructors.cpp \
				  02_destructors.cpp \
				  03_operator_equal.cpp \
				  04_top.cpp \
				  05_empty.cpp \
				  06_size.cpp \
				  07_push.cpp \
				  08_pop.cpp \
				  09_relationnal_operators.cpp


MAP				= 00_map_launcher.cpp \
				  01_pair_tests.cpp \
				  02_operator_equal.cpp \
				  03_constructors.cpp \
				  04_destructor.cpp \
				  05_clear.cpp \
				  06_value_key_comp.cpp \
				  07_swap.cpp \
				  08_iterators.cpp \
				  09_empty.cpp \
				  10_relational_operators.cpp \
				  11_bound.cpp \
				  12_allocator.cpp \
				  13_size.cpp \
				  14_max_size.cpp \
				  15_operator[].cpp \
				  16_insert.cpp \
				  17_erase.cpp \
				  18_find.cpp \
				  19_count.cpp




SRCS			= $(addprefix $(SRC_ROOTDIR), $(SRC_SUBDIR))



# **************************************************************************** #
#                                OBJECT FILES                                  #
# **************************************************************************** #


OBJ_ROOTDIR		= objs/

OBJ_SUBDIR		= $(SRC_SUBDIR:.cpp=.o)

OBJ_DIR 		= $(shell find ./unit_tests -type d | sed s/".\/unit_tests"/".\/objs"/g)

OBJS			= $(addprefix $(OBJ_ROOTDIR), $(OBJ_SUBDIR))

DEPENDS			:= $(OBJS:.o=.d)



# **************************************************************************** #
#                                  COLORS                                      #
# **************************************************************************** #


RED				= \033[31;1m
CYAN			= \033[36;1m
RESET			= \033[0m



# **************************************************************************** #
#                             MAKEFILE'S RULES                                 #
# **************************************************************************** #


.SILENT : 		all


all : 			header $(NAME) footer


$(OBJ_ROOTDIR)%.o: $(SRC_ROOTDIR)%.cpp
				@mkdir -p $(OBJ_DIR)
				$(CC) $(CFLAGS) $(INCLUDES) -MMD -MP -c $< -o $@


$(NAME)	: 		$(OBJS)
				@make -C unit_tests/framework --no-print-directory
				$(CC) $(LFLAGS) $(OBJS) $(LIBRARY) -o $(NAME)
				@printf "\n"


leaks :			all
				valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --error-exitcode=66 ./$(NAME) 2> valgrind.log


showleaks :		all
				valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --error-exitcode=66 ./$(NAME)

ft :
				$(CC) $(CFLAGS) -I containers -D FT=1 main.cpp -o ft
				$(CC) $(CFLAGS) -I containers main.cpp -o std
				./ft > ft.log
				./std > std.log

test :			all
				./$(NAME)


clean :
				@rm -rf $(OBJ_ROOTDIR) $(DEPENDS)
				@rm -rf VECTOR.log STACK.log MAP.log valgrind.log
				@make clean -C unit_tests/framework --no-print-directory
				@printf "$(RED)"
				@printf "Object files removed\n"
				@printf "$(RESET)"


fclean :
				@rm -rf ft std ft.log std.log
				@-rm -f $(NAME)
				@rm -rf VECTOR.log STACK.log MAP.log valgrind.log
				@-rm -rf $(OBJ_ROOTDIR) $(DEPENDS)
				@make fclean -C unit_tests/framework --no-print-directory
				@printf "$(RED)"
				@printf "Binary and object files removed\n"
				@printf "$(RESET)"


re :			fclean all


header :
				@printf "$(CYAN)"
				@printf "FT_CONTAINERS TESTER COMPILATION\n"
				@printf "$(RESET)"


footer :
				@printf "$(CYAN)"
				@printf "➤     SUCCESS\n"
				@printf "\nUSAGE\n"
				@printf "$(RESET)"
				@printf "./$(NAME)\n"


-include $(DEPENDS)


.PHONY : 		all clean fclean bonus re
