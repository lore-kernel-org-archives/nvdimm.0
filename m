Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C5C2C85
	for <nvdimm@lists.linux.dev>; Sun, 31 Oct 2021 13:30:20 +0000 (UTC)
Received: by mail-wr1-f49.google.com with SMTP id p14so24212435wrd.10
        for <nvdimm@lists.linux.dev>; Sun, 31 Oct 2021 06:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=h+YIJYU/CGpYORXj2rCNOHj6NcB2hgHRFq3Y9666r90=;
        b=LD28/wA2KmhiC3i90xJLFb78E+2twkKR1B8iIGy1bnvuIaJQhWM4XXT8HawRT0uG0h
         sykupdQV6oTshxzHi9W1gdlJfRWgXvXX4SDjBfT6ZmNaFF09cslX6St4nmUWpz+vmKYb
         lHDfh+1JS6iLdVXo+WoMvz6Q5cGgFWacIL0hzOvrw82blmJpXE5mqSOQnaBHorvcFMav
         TgefEQcBGp6/Lv4W7MKXndAI4WqzvgC+ZM4Yi/ycp878O89txr6idexRhUBq7Mw+pZpp
         rjOW7Q9cr8EClzi8oC656CkqoWLNwDjdh2wvWvpeknDmm8m3dt+Rqqr1KuKPfbH9cfRB
         bPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h+YIJYU/CGpYORXj2rCNOHj6NcB2hgHRFq3Y9666r90=;
        b=7GqX779pXeDSS52YLoJBPdhZ3cf27MaR3QiA0ZYyq+ju7Ho9vTsS8qbALxppTwgjQj
         40yX7abaVJzX1CQ4zg3MtGZOs2dJkY1qIIudEsdwkRvwR/tnlh1MMBN1zHXnGYda1IqC
         jSAVo7FPn6lDi0oLpgBT0xYZv+Jvx49z61Qh/ETZqwQ+bEwEItrrcq4NneAjPZHx7Ed9
         KpI5oEUScB/kmFDGs3BvGq3oTsVqsY7BH0X1b6ToCeUakgG4eH4xcrKeXny2E87QZSDn
         Kwh9YvD0z52v+OJ6r7Hxylx5kaNwT9HvDm2SwghcSOSMtluDJc3xF0tgebUf/nC8Xm61
         gz4Q==
X-Gm-Message-State: AOAM5305wNDe7D008qZ3YeCVbdjq2cIz192zgSNVhcgDhBuuvRbo2beL
	IreXxHQUYrGm05IVo/X46bg=
X-Google-Smtp-Source: ABdhPJyMAWA1Sez2ro/vxgbmSjihRwHdwamFfBYiCrFoLhmm0D7ZUE8z8CTE6ZXwZnPzfddj0lZYow==
X-Received: by 2002:a5d:5287:: with SMTP id c7mr31452951wrv.236.1635687018879;
        Sun, 31 Oct 2021 06:30:18 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.232.29])
        by smtp.gmail.com with ESMTPSA id n9sm10326016wmq.6.2021.10.31.06.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 06:30:18 -0700 (PDT)
Message-ID: <5f295bd5-8440-267e-f2e8-01572eddbbd6@gmail.com>
Date: Sun, 31 Oct 2021 13:27:08 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with RWF_RECOVERY_DATA
 flag
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig
 <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com"
 <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>,
 "willy@infradead.org" <willy@infradead.org>,
 "vgoyal@redhat.com" <vgoyal@redhat.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <YXFPfEGjoUaajjL4@infradead.org>
 <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
 <YXJN4s1HC/Y+KKg1@infradead.org>
 <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
 <YXj2lwrxRxHdr4hb@infradead.org> <20211028002451.GB2237511@magnolia>
 <20211028225955.GA449541@dread.disaster.area>
 <22255117-52de-4b2d-822e-b4bc50bbc52b@gmail.com>
 <20211029165747.GC2237511@magnolia>
 <f3e14569-a399-f6da-fd3e-993b579eaf74@gmail.com>
 <20211029200857.GD2237511@magnolia>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211029200857.GD2237511@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/21 21:08, Darrick J. Wong wrote:
> On Fri, Oct 29, 2021 at 08:23:53PM +0100, Pavel Begunkov wrote:
>> On 10/29/21 17:57, Darrick J. Wong wrote:
>>> On Fri, Oct 29, 2021 at 12:46:14PM +0100, Pavel Begunkov wrote:
>>>> On 10/28/21 23:59, Dave Chinner wrote:
>>>> [...]
>>>>>>> Well, my point is doing recovery from bit errors is by definition not
>>>>>>> the fast path.  Which is why I'd rather keep it away from the pmem
>>>>>>> read/write fast path, which also happens to be the (much more important)
>>>>>>> non-pmem read/write path.
>>>>>>
>>>>>> The trouble is, we really /do/ want to be able to (re)write the failed
>>>>>> area, and we probably want to try to read whatever we can.  Those are
>>>>>> reads and writes, not {pre,f}allocation activities.  This is where Dave
>>>>>> and I arrived at a month ago.
>>>>>>
>>>>>> Unless you'd be ok with a second IO path for recovery where we're
>>>>>> allowed to be slow?  That would probably have the same user interface
>>>>>> flag, just a different path into the pmem driver.
>>>>>
>>>>> I just don't see how 4 single line branches to propage RWF_RECOVERY
>>>>> down to the hardware is in any way an imposition on the fast path.
>>>>> It's no different for passing RWF_HIPRI down to the hardware *in the
>>>>> fast path* so that the IO runs the hardware in polling mode because
>>>>> it's faster for some hardware.
>>>>
>>>> Not particularly about this flag, but it is expensive. Surely looks
>>>> cheap when it's just one feature, but there are dozens of them with
>>>> limited applicability, default config kernels are already sluggish
>>>> when it comes to really fast devices and it's not getting better.
>>>> Also, pretty often every of them will add a bunch of extra checks
>>>> to fix something of whatever it would be.
>>>
>>> So we can't have data recovery because moving fast the only goal?
>>
>> That's not what was said and you missed the point, which was in
>> the rest of the message.
> 
> ...whatever point you were trying to make was so vague that it was
> totally uninformative and I completely missed it.
> 
> What does "callbacks or bit masks" mean, then, specifically?  How
> *exactly* would you solve the problem that Jane is seeking to solve by
> using callbacks?
> 
> Actually, you know what?  I'm so fed up with every single DAX
> conversation turning into a ****storm of people saying NO NO NO NO NO NO
> NO NO to everything proposed that I'm actually going to respond to
> whatever I think your point is, and you can defend whatever I come up
> with.

Interesting, I don't want to break it to you but nobody is going to
defend against yours made up out of thin air interpretations. I think
there is one thing we can relate, I wonder as well what the bloody
hell that opus of yours was


> 
>>>
>>> That's so meta.
>>>
>>> --D
>>>
>>>> So let's add a bit of pragmatism to the picture, if there is just one
>>>> user of a feature but it adds overhead for millions of machines that
>>>> won't ever use it, it's expensive.
> 
> Errors are infrequent, and since everything is cloud-based and disposble
> now, we can replace error handling with BUG_ON().  This will reduce code
> complexity, which will reduce code size, and improve icache usage.  Win!
> 
>>>> This one doesn't spill yet into paths I care about,
> 
> ...so you sail in and say 'no' even though you don't yet care...
> 
>>>> but in general
>>>> it'd be great if we start thinking more about such stuff instead of
>>>> throwing yet another if into the path, e.g. by shifting the overhead
>>>> from linear to a constant for cases that don't use it, for instance
>>>> with callbacks
> 
> Ok so after userspace calls into pread to access a DAX file, hits the
> poisoned memory line and the machinecheck fires, what then?  I guess we
> just have to figure out how to get from the MCA handler (assuming the
> machine doesn't just reboot instantly) all the way back into memcpy?
> Ok, you're in charge of figuring that out because I don't know how to do
> that.
> 
> Notably, RWF_DATA_RECOVERY is the flag that we're calling *from* a
> callback that happens after memory controller realizes it's lost
> something, kicks a notification to the OS kernel through ACPI, and the
> kernel signal userspace to do something about it.  Yeah, that's dumb
> since spinning rust already does all this for us, but that's pmem.
> 
>>>> or bit masks.
> 
> WTF does this even mean?
> 
> --D
> 
>>>>
>>>>> IOWs, saying that we shouldn't implement RWF_RECOVERY because it
>>>>> adds a handful of branches 	 the fast path is like saying that we
>>>>> shouldn't implement RWF_HIPRI because it slows down the fast path
>>>>> for non-polled IO....
>>>>>
>>>>> Just factor the actual recovery operations out into a separate
>>>>> function like:

-- 
Pavel Begunkov
