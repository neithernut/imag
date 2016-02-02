use libimagstore::store::Entry;

pub use ops::and::And;
pub use ops::not::Not;
pub use ops::or::Or;

pub trait Filter {

    fn filter(&self, &Entry) -> bool;

    fn not(self) -> Not
        where Self: Sized + 'static
    {
        Not::new(Box::new(self))
    }

    fn or(self, other: Box<Filter>) -> Or
        where Self: Sized + 'static
    {
        Or::new(Box::new(self), other)
    }

    fn and(self, other: Box<Filter>) -> And
        where Self: Sized + 'static
    {
        And::new(Box::new(self), other)
    }

}

