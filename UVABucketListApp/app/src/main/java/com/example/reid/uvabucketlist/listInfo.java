package com.example.reid.uvabucketlist;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import org.w3c.dom.Text;

import java.text.ParseException;

/**
 * Created by darth on 2/15/2016.
 */
public class listInfo extends Activity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_listinfo);

        Intent intent = getIntent();
        String action = intent.getAction();
        String itemName = intent.getStringExtra("itemName");
        boolean isIncomplete = intent.getBooleanExtra("isIncomplete", false);
        boolean isComplete = intent.getBooleanExtra("isComplete", false);

        CheckBox incompleteBox = (CheckBox) findViewById(R.id.checkbox_iBox2);
        CheckBox completeBox = (CheckBox) findViewById(R.id.checkbox_cBox2);

        TextView newItem = (TextView) findViewById(R.id.textView6);
        newItem.setText(itemName);

        if (isIncomplete) {
            incompleteBox.setChecked(true);
        } else {
            incompleteBox.setChecked(false);
        }
        if (isComplete) {
            completeBox.setChecked(true);
        } else {
            completeBox.setChecked(false);
        }

        TextView descriptionText = (TextView) findViewById(R.id.textView7);
        String description;
        String[] splitString = itemName.split("\\)");
        int number;
        try {
            number = Integer.parseInt(splitString[0]);
        } catch (NumberFormatException e) {
            number = 0;
        }
        switch (number) {
            case 1:
                description = "Get together with the UVa crowd and sing arm-in-arm the Good Ole Song.";
                break;
            case 2:
                description = "Everyone's done it but you, strip down to as much as you're comfortable and run around like a lunatic.";
                break;
            case 3:
                description = "Find the elusive Dean Groves and show him who's Hoo by giving him a high-five.";
                break;
            case 4:
                description = "Go out and find one of the many Improv Shows available at UVa and enjoy!";
                break;
            case 5:
                description = "Pancakes are delicious, and helping donate to the Parkinson's cause is just as great, so why not do both at the same time?";
                break;
            case 6:
                description = "The AFC offers so many classes for FREE! Why not take advantage of it to learn something new and exciting?";
                break;
            case 7:
                description = "Your dorm mates from First Year have wanted to get back together with you since after the first day of Summer, why not get together again?";
                break;
            case 8:
                description = "Good ole TJ may be dead and gone, but that won't stop you from getting a selfie with his likeness to post to your social media accounts.";
                break;
            case 9:
                description = "The two-party system is a sham, so why not get into it as early as possible through the U.Va. Student Elections!! (Your vote may not matter, depending on the government currently in place)";
                break;
            case 10:
                description = "Wine is just fermented grape juice, but it does make you feel all fuzzy inside. Why not make a day of it?";
                break;
            case 11:
                description = "Crozet may actually be over 50 miles away, but that won't stop you from going to a restaurant named after it, and neither will Buddhist Bikers.";
                break;
            case 12:
                description = "You gained that Freshman 15, why not spend the time now to feel bad about your life choices by running more than you have in the past 5 years?";
                break;
            case 13:
                description = "Annoy people who live on the Lawn by pitching up a campsite, complete with campfire, tents, chairs, grills, and all the works so that you can have a picnic and make them feel bad!";
                break;
            case 14:
                description = "Beer is great, and it's not like you haven't been drinking it illegally for at least the past 3 years, why not do it legally where they brew it fresh?";
                break;
            case 15:
                description = "I have no clue why this is on the Bucket List. The bus sucks.";
                break;
            case 16:
                description = "Jazz is the ultimate form of creativity, and Thursday is named after the ultimate Norse God Thor, so surely the two must go together perfectly?";
                break;
            case 17:
                description = "You know what's cool? Lights. You know what's cooler? Watching lights turn on. Why not do it with half of the campus for about 30 seconds and then feel like you wasted your whole night!";
                break;
            case 18:
                description = "I may have injured myself the last time I attempted to go ice skating, but that shouldn't stop you from doing it Downtown!";
                break;
            case 19:
                description = "The night has gotten out of control, take it back by saying that you will but then find out that nothing really happens where you live, and eventually do nothing!";
                break;
            case 20:
                description = "First years are annoying, cheery, eager, excited, and inquisitive, all the things you stopped being after your First-Year. Why not make friends with them?!";
                break;
            case 21:
                description = "The James River, named after the Great King James. I have no joke about it. Just go tubing.";
                break;
            case 22:
                description = "Maybe it hasn't snowed over the past 3 years that you've been at UVA, but that shouldn't be able to stop you from mudsledding into the street full of cars that can't see from the downpour!";
                break;
            case 23:
                description = "Virginia may not be particularly known for their A-class film, but you liked that one 10 minute foreign film, so it'll be fine? Right. RIGHT?!";
                break;
            case 24:
                description = "Frozen Yogurt. The perfect treat to make you feel like you're healthy by calling it yogurt, but still packed with all that goodness that actually makes it bad for you!";
                break;
            default:
                description = "NO AVAILABLE DESCRIPTION!";
                break;
        }
        descriptionText.setText(description);

    }

    public void exitInfo(View view) {
        finish();
    }

    public void saveInfo(View view) {
        Intent oldIntent = getIntent();
        String editedItem = oldIntent.getStringExtra("itemName");

        Intent intent = new Intent(listInfo.this, ListDisplay.class);

        CheckBox incompleteBox = (CheckBox) findViewById(R.id.checkbox_iBox2);
        CheckBox completeBox = (CheckBox) findViewById(R.id.checkbox_cBox2);


        if (incompleteBox.isChecked()) {
            intent.putExtra("editIncomplete", true);
        }
        if (completeBox.isChecked()) {
            intent.putExtra("editComplete", true);
        }
        intent.putExtra("editedItem", editedItem);
        setResult(Activity.RESULT_OK, intent);
        finish();
    }

}