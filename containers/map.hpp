/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   map.hpp                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: cmariot <cmariot@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/07/12 15:45:28 by cmariot           #+#    #+#             */
/*   Updated: 2022/07/19 20:36:28 by cmariot          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef MAP_HPP
# define MAP_HPP

# include <cstddef>
# include <memory>
# include <iostream>
# include <limits>

# include "../utils/RBTree.hpp"
# include "../utils/enable_if.hpp"
# include "../utils/utils.hpp"
# include "../iterators/bidirectional_iterator.hpp"
# include "../iterators/reverse_iterator.hpp"
# include "../utils/pair.hpp"

namespace ft
{

	/* TO DO :
	 * - [X] MEMBER TYPES
	 * - [X] RED-BLACK TREE :
	      - [X] UTILISER ALLOCATOR DE MAP
	      - [X] UTILISER COMP DE MAP
	 * - [X] CONSTRUCTORS
	 * - [X] DESTRUCTOR
	 * - [X] OPERATOR =
	 * - [ ] ITERATORS :
		 - [ ] BEGIN
		 - [ ] END
		 - [ ] RBEGIN
		 - [ ] REND
	 * - [X] CAPACITY
		 - [X] SIZE
		 - [X] EMPTY
		 - [X] MAX SIZE
	 * - [ ] ELEMENT ACCESS :
		 * - [ ] OPERATOR []
	 * - [ ] MODIFIERS :
		 - [/] INSERT
		 - [ ] ERASE
		 - [ ] SWAP
		 - [X] CLEAR
	 * - [X] OBSERVERS :
	 *   - [X] KEY COMP
	 *   - [X] VALUE COMP
	 * - [ ] OPERATIONS :
		 - [ ] FIND
		 - [ ] COUNT
		 - [ ] LOWER_BOUND
		 - [ ] UPPER_BOUND
		 - [ ] EQUAL_RANGE
	 * - [X] ALLOCATOR
		 - [X] GET_ALLOCATOR
	 */

	template <class Key,
			 class Value,
			 class Compare = std::less<Key>,
			 class Allocator = std::allocator<ft::pair<const Key, Value> > >
	class map
	{

		// MEMBER TYPES
		public :

			typedef Key												key_type;
			typedef Value											mapped_type;
			typedef ft::pair<Key, Value>							value_type;
			typedef size_t											size_type;
			typedef ptrdiff_t										difference_type;
			typedef Compare											key_compare;
			typedef Allocator										allocator_type;
			typedef value_type &									reference;
			typedef const value_type &								const_reference;
			typedef typename Allocator::pointer						pointer;
			typedef typename Allocator::const_pointer				const_pointer;
			typedef value_type *	 								iterator;			// a implementer
			//typedef typename		T*								const_iterator;		// a implementer
			//typedef typename ft::reverse_iterator<iterator>			reverse_iterator;
			//typedef typename ft::reverse_iterator<const_iterator>	const_reverse_iterator;

		// PRIVATE MEMBER OBJECTS
		public :

			typedef ft::RedBlackTree<key_type, mapped_type, key_compare, std::allocator<ft::Node<key_type, mapped_type> > >		red_black_tree;

			key_compare							_comp;
			allocator_type						_alloc;
			size_type							_size;
			red_black_tree						_tree;

		public :
			// MEMBER CLASS
			// Here the keyword friend is allowed
			class value_compare
			{

				// MEMBER TYPES
				public :

					typedef bool								result_type;
					typedef value_type							first_argument_type;
					typedef value_type							second_argument_type;

				// PROTECTED MEMBER OBJECTS
				protected :

					Compare										comp;

				// MEMBER FUNCTIONS
				protected :

					// CONSTRUCTOR
					value_compare(Compare c) :
						comp(c)
					{
						return ;
					};

					// OPERATOR ()
					bool operator () (const value_type & lhs, const value_type & rhs) const
					{
						return (comp(lhs.first, rhs.first));
					};

			};

			// MEMBER FUNCTIONS

				// DEFAULT CONSTRUCTOR
				explicit map(const key_compare & comp = key_compare(),
							 const allocator_type & alloc = allocator_type()) :
								_comp(comp),
								_alloc(alloc),
								_size(0)
				{
					_tree = red_black_tree(_alloc, _comp);
					return ;
				};

				// RANGE CONSTRUCTOR
				template <class InputIterator>
				map(InputIterator first,
					InputIterator last,
					const key_compare& comp = key_compare(),
					const allocator_type& alloc = allocator_type()) :
							_comp(comp),
							_alloc(alloc),
							_size(0)
				{
					_tree = red_black_tree(_alloc, _comp);
					while (first != last)
					{
						_tree.add(*first->first, *first->second);
						++first;
						_size++;
					}
					return ;
				};

				// COPY CONSTRUCTOR
				map(const map & x)
				{
					this = map(x.begin(), x.end(), x.key_comp(), x.get_allocator());
					return ;
				};

				// OPERATOR =
				map& operator = (const map& other)
				{
					~this();
					this = map(other);
					return (*this);
				};

				// EMPTY
				bool empty(void) const
				{
					return (_size == 0);
				};

				// SIZE
				size_type size(void) const
				{
					return (_size);
				};

				// MAX SIZE
				size_type max_size(void) const
				{
					return (std::numeric_limits<difference_type>::max());
				};
			
				mapped_type& operator[] (const key_type& k)
				{
					return ((*((insert(ft::make_pair(k, mapped_type()))).first)).second);
				};

				//INSERT
				pair<iterator,bool> insert(const value_type& val)
				{
					_tree.add(val.first, val.second);
					_size++;
					return (ft::pair<iterator, bool>(iterator(), true));
				};

				// CLEAR
				void clear(void)
				{
					_tree.~red_black_tree();
					_tree = red_black_tree();
					_size = 0;
				};

				// KEY COMP
				key_compare key_comp(void) const
				{
					return (_comp);
				};

				// VALUE COMP
				value_compare value_comp(void) const
				{
					return (value_compare(_comp));
				};

				// GET ALLOCATOR
				allocator_type get_allocator(void) const
				{
					return (_alloc);
				};
	};

};

#endif
