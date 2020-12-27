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
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet1.cages_empty_occupied". При необходимости она может быть перемещена или удалена.
            this.cages_empty_occupiedTableAdapter.Fill(this.friendDataSet1.cages_empty_occupied);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "friendDataSet1.available_pets_view". При необходимости она может быть перемещена или удалена.
            this.available_pets_viewTableAdapter.Fill(this.friendDataSet1.available_pets_view);
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
            dataGridView1.Sort(dataGridView1.Columns[0], ListSortDirection.Ascending);
            dataGridView3.Sort(dataGridView3.Columns[0], ListSortDirection.Ascending);
            dataGridView5.Sort(dataGridView5.Columns[0], ListSortDirection.Ascending);
            dataGridView6.Sort(dataGridView6.Columns[0], ListSortDirection.Ascending);
            dataGridView7.Sort(dataGridView7.Columns[0], ListSortDirection.Ascending);
            dataGridView8.Sort(dataGridView8.Columns[0], ListSortDirection.Ascending);
            dataGridView11.Sort(dataGridView11.Columns[0], ListSortDirection.Ascending);
            dataGridView9.Sort(dataGridView9.Columns[2], ListSortDirection.Ascending);
            dataGridView10.Sort(dataGridView10.Columns[0], ListSortDirection.Ascending);
            dataGridView2.Sort(dataGridView2.Columns[0], ListSortDirection.Ascending);
            dataGridView4.Sort(dataGridView4.Columns[0], ListSortDirection.Ascending);
        }

        private void dataGridView3_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == 6)
            {
                OpenFileDialog dlg = new OpenFileDialog();
                DialogResult dr = dlg.ShowDialog();
                if (dr == System.Windows.Forms.DialogResult.OK)
                {
                    string filename = dlg.FileName;
                    ((DataGridViewImageCell)dataGridView3.Rows[e.RowIndex].Cells[6]).Value = Image.FromFile(filename);
                }
            }
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
                Form1_Load(sender, e);
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

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == 7)
            {
                OpenFileDialog dlg = new OpenFileDialog();
                DialogResult dr = dlg.ShowDialog();
                if (dr == System.Windows.Forms.DialogResult.OK)
                {
                    string filename = dlg.FileName;
                    ((DataGridViewImageCell)dataGridView1.Rows[e.RowIndex].Cells[7]).Value = Image.FromFile(filename);
                }
                /*string FileName = null;

                OpenFileDialog openFileDialog = new OpenFileDialog();
                openFileDialog.RestoreDirectory = true;

                openFileDialog.Filter = "All picture files (*.BMP;*.JPG;*.GIF)|*.BMP;*.JPG;*.GIF";

                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    FileName = openFileDialog.FileName;
                    petsBindingSource.Current.
                    //pictureBox2.Image = Image.FromFile(FileName);
                }*/
            }
        }

        private void кормлениеПоЖивотномуToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 14;
        }


        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
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
                Form1_Load(sender, e);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Message", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            Cursor.Current = Cursors.Default;
        }

        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void клеткиToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 7;
        }

        private void видыЖивотныхToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 9;
        }

        private void списокПоловToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 10;
        }

        private void rpovidersToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 6;
        }

        private void clientsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 5;
        }

        private void animalsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 0;
        }

        private void кормаToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 8;
        }

        private void transactionsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 4;
        }

        private void suppliesToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 1;
        }

        private void placementsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 2;
        }

        private void кормленияToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 3;
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
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
            if (this.friendDataSet1.HasChanges())
            {
                if (MessageBox.Show("Имеются несохраненные изменения. Сохранить?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                {
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
            }

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            //dataGridViewCustomersReport.DataSource.DefaultView.Ro
            //friendDataSet1.transactions.FillByParam(2)
            if(comboBox1.SelectedValue != null)
                this.transactionsTableAdapter.FillByParam(this.friendDataSet4.transactions, (int)comboBox1.SelectedValue);
        }

        private void fillByParamToolStripButton_Click(object sender, EventArgs e)
        {
            /*try
            {
                this.transactionsTableAdapter.FillByParam(this.friendDataSet4.transactions, ((int)(System.Convert.ChangeType(customer_idToolStripTextBox.Text, typeof(int)))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
            */
        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBoxProvider.SelectedValue != null)
                this.suppliesTableAdapter.FillByParam(this.friendDataSet4.supplies, (int)comboBoxProvider.SelectedValue);
        }

        private void fillByParamToolStripButton_Click_1(object sender, EventArgs e)
        {
            /*try
            {
                this.suppliesTableAdapter.FillByParam(this.friendDataSet4.supplies, ((int)(System.Convert.ChangeType(provider_idToolStripTextBox.Text, typeof(int)))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
            */
        }

        private void dataGridView12_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            
        }

        private void comboBoxPetFeed_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBoxPetFeed.SelectedValue != null)
                this.feedingsTableAdapter.FillByParam(this.friendDataSet4.feedings, (int)comboBoxPetFeed.SelectedValue);
        }

        private void fillByParamToolStripButton_Click_2(object sender, EventArgs e)
        {
            /*try
            {
                this.feedingsTableAdapter.FillByParam(this.friendDataSet4.feedings, ((int)(System.Convert.ChangeType(pet_idToolStripTextBox.Text, typeof(int)))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
            */
        }

        private void fillByParamToolStripButton_Click_3(object sender, EventArgs e)
        {
            /*try
            {
                this.placementsTableAdapter.FillByParam(this.friendDataSet4.placements, ((int)(System.Convert.ChangeType(pet_idToolStripTextBox.Text, typeof(int)))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
            */
        }

        private void comboBoxPlacePet_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBoxPlacePet.SelectedValue != null)
                this.placementsTableAdapter.FillByParam(this.friendDataSet4.placements, (int)comboBoxPlacePet.SelectedValue);
        }

        private void cagesReportToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 16;
        }

        private void transactionsReportToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 12;
        }

        private void suppliesReportToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 13;
        }

        private void placementsReportToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 15;
        }

        private void availablePetsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 11;
        }
    }
}
