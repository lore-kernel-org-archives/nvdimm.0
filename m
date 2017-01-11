From: Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v6] x86: fix kaslr and memmap collision
Date: Wed, 11 Jan 2017 10:59:30 -0700
Message-ID: <1a30ba47-1a60-5275-93da-606f8d577797@intel.com>
References: <148407086864.34638.4228724339196415751.stgit@djiang5-desk3.ch.intel.com>
 <alpine.DEB.2.20.1701111246400.3579@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1701111246400.3579@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, linux-nvdimm@ml01.01.org, x86@kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org, dan.j.williams@intel.com
List-Id: linux-nvdimm@lists.01.org



On 01/11/2017 05:00 AM, Thomas Gleixner wrote:
> On Tue, 10 Jan 2017, Dave Jiang wrote:
>> +unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base);
>> +long simple_strtol(const char *cp, char **endp, unsigned int base);
> 
> What are those functions for? They are not used in that patch at all.

My mistake. Those were used for something in earlier versions of the
patch and I forgot to take them out now they aren't being used. Will remove.

> 
>> +static void mem_avoid_memmap(void)
>> +{
>> +	char arg[128];
>> +	int rc = 0;
> 
> What's the point of defining this variable here and zero initializing it?

It was necessary when the function was returning int instead of void. I
will move.

> 
>> +	/* see if we have any memmap areas */
> 
> Sentences start with an upper case letter. Everywhere!

Will fix.

> 
>> +	if (cmdline_find_option("memmap", arg, sizeof(arg)) > 0) {
> 
> You can spare an indentation level by just returning when the search fails.

Will update.

> 
>> +		int i = 0;
>> +		char *str = arg;
>> +
>> +		while (str && (i < MAX_MEMMAP_REGIONS)) {
> 
> 	for (i = 0; str && (i < MAX_MEMMAP_REGIONS); i++) {
> 
> Please.

The reason it's a while is so that when we hit an instance of
memmap=nn@ss we can conditionally skip it without having to increment
the counter 'i'.

> 
>> +			unsigned long long start, size;
>> +			char *k = strchr(str, ',');
>> +
>> +			if (k)
>> +				*k++ = 0;
>> +
>> +			rc = parse_memmap(str, &start, &size);
>> +			if (rc < 0)
>> +				break;
>> +			str = k;
>> +			/* a usable region that should not be skipped */
>> +			if (size == 0)
>> +				continue;
>> +
>> +			mem_avoid[MEM_AVOID_MEMMAP_BEGIN + i].start = start;
>> +			mem_avoid[MEM_AVOID_MEMMAP_BEGIN + i].size = size;
> 
> So this makes no sense. You parse start/size as unsigned long long and
> then store it in an unsigned long. Works on 64bit, but on 32bit this is
> just wrong:
> 
> Assume a memmap above 4G, which then will create a avoid region below 4G
> due to truncation to unsigned long.

Ok so it looks like an issue for 32bit on the original code? I'm
presuming none of the previous mem avoid regions are over 4G so that
wasn't an issue? I will update the data structure to use unsigned long
long.

Thanks for the review!

> 
> Thanks,
> 
> 	tglx
> 
