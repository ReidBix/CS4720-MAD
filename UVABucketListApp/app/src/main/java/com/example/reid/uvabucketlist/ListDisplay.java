package com.example.reid.uvabucketlist;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ListView;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;
import java.util.ArrayList;



/**
 * Created by darth on 2/8/2016.
 */

public class ListDisplay extends Activity {
    // Array of strings...
    ArrayList<String> incompleteArray = new ArrayList<String>(){
        {
            add("1) Sing the Good Ole Song");
            add("2) Streak the Lawn");
            add("3) High-five Dean Groves");
            add("4) Watch an Improv Show");
            add("5) Eat a Pancake for Parkinson's");
            add("6) Attend an AFC Drop-In Class");
            add("7) Plan a Dorm Reunion");
            add("8) Take a Picture with Thomas Jefferson");
            add("9) Vote in the U.Va. Student Elections");
            add("10) Go Wine Tasting");
            add("11) Eat at Crozet Pizza");
            add("12) Run the 4th Year 5K");
        }};
    ArrayList<String> completeArray = new ArrayList<String>(){
        {
            add("13) Eat a Picnic on the Lawn");
            add("14) Check Out One of C'ville's breweries");
            add("15) Ride the UTS Bus");
            add("16) Go to Miller's Thursday Jazz");
            add("17) See the Lighting of the Lawn");
            add("18) Ice Skate Downtown");
            add("19) Take Back the Night");
            add("20) Befriend a First Year");
            add("21) Tube Down the James");
            add("22) Sled Anywhere on Grounds");
            add("23) Go to the VA Film Festival");
            add("24) Enjoy Some Froyo at Arch's");
        }};

    int infoRequestCode;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (savedInstanceState == null || !savedInstanceState.containsKey("check")) {
            incompleteArray = incompleteArray;
            completeArray = completeArray;
        } else {
            incompleteArray = savedInstanceState.getStringArrayList("incompleteArray");
            completeArray = savedInstanceState.getStringArrayList("completeArray");
        }

        setContentView(R.layout.activity_main);

        final ArrayAdapter adapterI = new ArrayAdapter<String>(this, R.layout.activity_listview, incompleteArray);
        final ArrayAdapter adapterC = new ArrayAdapter<String>(this, R.layout.activity_listview, completeArray);

        final ListView listViewI = (ListView) findViewById(R.id.incomplete_list);
        listViewI.setAdapter(adapterI);

        final ListView listViewC = (ListView) findViewById(R.id.complete_list);
        listViewC.setAdapter(adapterC);


        listViewI.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                CheckBox incompleteBox = (CheckBox)findViewById(R.id.checkbox_iBox);
                CheckBox completeBox = (CheckBox)findViewById(R.id.checkbox_cBox);

                Object o = listViewI.getItemAtPosition(position);
                EditText newItem = (EditText) findViewById(R.id.editText);
                String oString = o.toString();
                newItem.setText(oString);

                boolean isIncomplete = false;
                boolean isComplete = false;

                if (incompleteArray.contains(oString)) {
                    incompleteBox.setChecked(true);
                    isIncomplete = true;
                } else {
                    incompleteBox.setChecked(false);
                }
                if (completeArray.contains(oString)) {
                    completeBox.setChecked(true);
                    isComplete = true;
                } else {
                    completeBox.setChecked(false);
                }


                // AND OPEN NEW PAGE
                Intent intent = new Intent(ListDisplay.this, listInfo.class);
                intent.putExtra("itemName", oString);
                intent.putExtra("isIncomplete", isIncomplete);
                intent.putExtra("isComplete", isComplete);
                startActivityForResult(intent, infoRequestCode);
            }
        });

        listViewC.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                CheckBox incompleteBox = (CheckBox)findViewById(R.id.checkbox_iBox);
                CheckBox completeBox = (CheckBox)findViewById(R.id.checkbox_cBox);

                Object o = listViewC.getItemAtPosition(position);
                EditText newItem = (EditText) findViewById(R.id.editText);
                String oString = o.toString();
                newItem.setText(oString);
                boolean isIncomplete = false;
                boolean isComplete = false;

                if (incompleteArray.contains(oString)) {
                    incompleteBox.setChecked(true);
                    isIncomplete = true;
                } else {
                    incompleteBox.setChecked(false);
                }
                if (completeArray.contains(oString)) {
                    completeBox.setChecked(true);
                    isComplete = true;
                } else {
                    completeBox.setChecked(false);
                }


                // AND OPEN NEW PAGE
                Intent intent = new Intent(ListDisplay.this, listInfo.class);
                intent.putExtra("itemName", oString);
                intent.putExtra("isIncomplete", isIncomplete);
                intent.putExtra("isComplete", isComplete);
                startActivityForResult(intent, infoRequestCode);
            }
        });

        listViewI.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                Context context = getApplicationContext();
                CharSequence iText = "Incomplete List already contains item!";
                int duration = Toast.LENGTH_SHORT;

                Object o = listViewI.getItemAtPosition(position);
                String oString = o.toString();
                incompleteArray.remove(oString);
                if (!completeArray.contains(oString)) {
                    completeArray.add(oString);
                } else {
                    Toast toast = Toast.makeText(context, iText, duration);
                    toast.show();
                }
                adapterI.notifyDataSetChanged();
                adapterC.notifyDataSetChanged();
                return true;
            }
        });

        listViewC.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener(){
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                Context context = getApplicationContext();
                CharSequence cText = "Complete List already contains item!";
                int duration = Toast.LENGTH_SHORT;

                Object o = listViewC.getItemAtPosition(position);
                String oString = o.toString();
                completeArray.remove(oString);
                if (!incompleteArray.contains(oString)) {
                    incompleteArray.add(oString);
                } else {
                    Toast toast = Toast.makeText(context, cText, duration);
                    toast.show();
                }
                adapterI.notifyDataSetChanged();
                adapterC.notifyDataSetChanged();
                return true;
            }
        });


        Button addItem = (Button)findViewById(R.id.button);
        addItem.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Context context = getApplicationContext();
                CharSequence iText = "Incomplete List already contains item!";
                CharSequence cText = "Complete List already contains item!";
                int duration = Toast.LENGTH_SHORT;

                final CheckBox incompleteBox = (CheckBox)findViewById(R.id.checkbox_iBox);
                final CheckBox completeBox = (CheckBox)findViewById(R.id.checkbox_cBox);

                EditText newItem = (EditText) findViewById(R.id.editText);
                String newItemString = newItem.getText().toString();
                if (!newItemString.equals("")) {
                    if (incompleteBox.isChecked()) {
                        if (!incompleteArray.contains(newItemString)) {
                            incompleteArray.add(newItemString);
                        } else {
                            Toast toast = Toast.makeText(context, iText, duration);
                            toast.show();
                        }
                    }
                    if (completeBox.isChecked()) {
                        if (!completeArray.contains(newItemString)) {
                            completeArray.add(newItemString);
                        } else {
                            Toast toast = Toast.makeText(context, cText, duration);
                            toast.show();
                        }
                    }
                }
                adapterI.notifyDataSetChanged();
                adapterC.notifyDataSetChanged();
                newItem.setText("");
            }
        });

        Button removeItem = (Button)findViewById(R.id.button2);
        removeItem.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Context context = getApplicationContext();
                CharSequence iText = "Incomplete List doesn't contain item!";
                CharSequence cText = "Complete List doesn't contain item!";
                int duration = Toast.LENGTH_SHORT;

                final CheckBox incompleteBox = (CheckBox) findViewById(R.id.checkbox_iBox);
                final CheckBox completeBox = (CheckBox) findViewById(R.id.checkbox_cBox);

                EditText newItem = (EditText) findViewById(R.id.editText);
                String newItemString = newItem.getText().toString();
                if (!newItemString.equals("")) {
                    if (incompleteBox.isChecked()) {
                        if (incompleteArray.contains(newItemString)) {
                            incompleteArray.remove(newItemString);
                        } else {
                            Toast toast = Toast.makeText(context, iText, duration);
                            toast.show();
                        }
                    }
                    if (completeBox.isChecked()) {
                        if (completeArray.contains(newItemString)) {
                            completeArray.remove(newItemString);
                        } else {
                            Toast toast = Toast.makeText(context, cText, duration);
                            toast.show();
                        }
                    }
                }
                adapterI.notifyDataSetChanged();
                adapterC.notifyDataSetChanged();
                newItem.setText("");
            }
        });
    }

    @Override
    public void onSaveInstanceState(Bundle savedInstanceState) {
        super.onSaveInstanceState(savedInstanceState);
        savedInstanceState.putStringArrayList("incompleteArray", incompleteArray);
        savedInstanceState.putStringArrayList("completeArray", completeArray);
        savedInstanceState.putBoolean("check",true);
    }

    @Override
    public void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
        incompleteArray = savedInstanceState.getStringArrayList("incompleteArray");
        completeArray = savedInstanceState.getStringArrayList("completeArray");
        boolean check = savedInstanceState.getBoolean("check");
    }


    public void clearEdit(View view) {
        CheckBox incompleteBox = (CheckBox)findViewById(R.id.checkbox_iBox);
        CheckBox completeBox = (CheckBox)findViewById(R.id.checkbox_cBox);

        EditText text = (EditText)findViewById(R.id.editText);
        text.setText("");

        incompleteBox.setChecked(false);
        completeBox.setChecked(false);
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == infoRequestCode && resultCode == RESULT_OK && data != null) {
//            final ArrayAdapter adapterI = new ArrayAdapter<String>(this, R.layout.activity_listview, incompleteArray);
//            final ArrayAdapter adapterC = new ArrayAdapter<String>(this, R.layout.activity_listview, completeArray);

            String editedItem = data.getStringExtra("editedItem");
            boolean editIncomplete = data.getBooleanExtra("editIncomplete", false);
            boolean editComplete = data.getBooleanExtra("editComplete", false);
            TextView edit = (TextView) findViewById(R.id.textView);
            edit.setText(editedItem);

            if (incompleteArray.contains(editedItem)) {
                if (!editIncomplete) {
                    incompleteArray.remove(editedItem);
                }
            } else if (editIncomplete) {
                incompleteArray.add(editedItem);
            }
            if (completeArray.contains(editedItem)) {
                if (!editComplete) {
                    completeArray.remove(editedItem);
                }
            } else if (editComplete) {
                completeArray.add(editedItem);
            }
            this.onCreate(new Bundle());
        }

    }

}

