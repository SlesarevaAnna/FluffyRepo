using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Npgsql;

namespace FluffyFriend
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            /*NpgsqlConnection conn = new NpgsqlConnection("Server=localhost;Port=5432;Database=fluffy_friend;User Id=postgres;Password=676262;");
            conn.Open();
            NpgsqlCommand comm = new NpgsqlCommand();
            comm.Connection = conn;
            comm.CommandType = CommandType.Text;
            comm.CommandText = "select * from available_pets_view";
            NpgsqlDataReader dr = comm.ExecuteReader();
            if(dr.HasRows)
            {
                DataTable dt = new DataTable();
                dt.Load(dr);
                dataGridView1.DataSource = dt;
            }
            


            conn.Dispose();
            conn.Close();*/
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet1.cage_name_plus". При необходимости она может быть перемещена или удалена.
            this.cage_name_plusTableAdapter.Fill(this.friendDataSet1.cage_name_plus);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet4.customer_name_plus". При необходимости она может быть перемещена или удалена.
            this.customer_name_plusTableAdapter.Fill(this.friendDataSet4.customer_name_plus);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet3.pet_name_plus". При необходимости она может быть перемещена или удалена.
            this.pet_name_plusTableAdapter.Fill(this.friendDataSet3.pet_name_plus);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet1.supplies". При необходимости она может быть перемещена или удалена.
            this.suppliesTableAdapter.Fill(this.friendDataSet1.supplies);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet1.transactions". При необходимости она может быть перемещена или удалена.
            this.transactionsTableAdapter.Fill(this.friendDataSet1.transactions);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet1.feedinds". При необходимости она может быть перемещена или удалена.
            this.feedingsTableAdapter.Fill(this.friendDataSet1.feedings);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet1.placements". При необходимости она может быть перемещена или удалена.
            this.placementsTableAdapter.Fill(this.friendDataSet1.placements);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet2.foods". При необходимости она может быть перемещена или удалена.
            this.foodsTableAdapter.Fill(this.friendDataSet1.foods);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet1.cages". При необходимости она может быть перемещена или удалена.
            this.cagesTableAdapter.Fill(this.friendDataSet1.cages);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet.providers". При необходимости она может быть перемещена или удалена.
            this.providersTableAdapter.Fill(this.friendDataSet1.providers);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet1.species". При необходимости она может быть перемещена или удалена.
            this.speciesTableAdapter.Fill(this.friendDataSet1.species);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet1.pets". При необходимости она может быть перемещена или удалена.
            this.petsTableAdapter.Fill(this.friendDataSet1.pets);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet1.sexes". При необходимости она может быть перемещена или удалена.
            this.sexesTableAdapter.Fill(this.friendDataSet1.sexes);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet1.customers". При необходимости она может быть перемещена или удалена.
            this.customersTableAdapter.Fill(this.friendDataSet1.customers);

        }

        private void dataGridView3_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void save_button_Click(object sender, EventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
            try
            {
                petsBindingSource.EndEdit();
                customersBindingSource.EndEdit();
                speciesBindingSource.EndEdit();
                sexesBindingSource.EndEdit();
                providersBindingSource.EndEdit();
                cagesBindingSource.EndEdit();
                foodsBindingSource.EndEdit();
                placementsBindingSource.EndEdit();
                feedingsBindingSource.EndEdit();
                transactionsBindingSource.EndEdit();
                suppliesBindingSource.EndEdit();
                petsTableAdapter.Update(this.friendDataSet1.pets);
                customersTableAdapter.Update(this.friendDataSet1.customers);
                speciesTableAdapter.Update(this.friendDataSet1.species);
                sexesTableAdapter.Update(this.friendDataSet1.sexes);
                providersTableAdapter.Update(this.friendDataSet1.providers);
                cagesTableAdapter.Update(this.friendDataSet1.cages);
                foodsTableAdapter.Update(this.friendDataSet1.foods);
                placementsTableAdapter.Update(this.friendDataSet1.placements);
                feedingsTableAdapter.Update(this.friendDataSet1.feedings);
                transactionsTableAdapter.Update(this.friendDataSet1.transactions);
                suppliesTableAdapter.Update(this.friendDataSet1.supplies);
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message, "Message", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            Cursor.Current = Cursors.Default;
        }

        private void dataGridView1_KeyDown(object sender, KeyEventArgs e)
        {
            if(e.KeyCode == Keys.Delete)
            {
                if (MessageBox.Show("Вы реально хотите удалить запись этого животного?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                    petsBindingSource.RemoveCurrent();
            }
        }

        private void dataGridView3_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                if (MessageBox.Show("Вы реально хотите удалить запись этого клиента?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                    customersBindingSource.RemoveCurrent();
            }
        }

        private void dataGridView2_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                if (MessageBox.Show("Вы реально хотите удалить этот вид?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                   speciesBindingSource.RemoveCurrent();
            }
        }

        private void dataGridView4_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                if (MessageBox.Show("Вы реально хотите удалить этот пол?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                    sexesBindingSource.RemoveCurrent();
            }
        }

        private void dataGridView5_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                if (MessageBox.Show("Вы реально хотите удалить этого поставщика?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                    providersBindingSource.RemoveCurrent();
            }
        }

        private void dataGridView6_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                if (MessageBox.Show("Вы реально хотите удалить данную клетку?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                    cagesBindingSource.RemoveCurrent();
            }
        }

        private void dataGridView7_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                if (MessageBox.Show("Вы реально хотите удалить данный вид корма?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                    foodsBindingSource.RemoveCurrent();
            }
        }

        private void dataGridView8_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                if (MessageBox.Show("Вы реально хотите удалить данное размещение?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                    placementsBindingSource.RemoveCurrent();
            }
        }

        private void dataGridView9_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                if (MessageBox.Show("Вы реально хотите удалить данное кормление?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                    feedingsBindingSource.RemoveCurrent();
            }
        }

        private void dataGridView10_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                if (MessageBox.Show("Вы реально хотите удалить данную продажу?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                    transactionsBindingSource.RemoveCurrent();
            }
        }

        private void dataGridView11_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                if (MessageBox.Show("Вы реально хотите удалить данную поставку?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                    suppliesBindingSource.RemoveCurrent();
            }
        }
    }
}
