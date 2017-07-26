Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22d.google.com (mail-yw0-x22d.google.com
 [IPv6:2607:f8b0:4002:c05::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5DA0B21D28FE9
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 17:01:23 -0700 (PDT)
Received: by mail-yw0-x22d.google.com with SMTP id x125so78125906ywa.0
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 17:03:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170725235512.GC23846@kernel.org>
References: <150102217021.2258.1380624380896006.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150102218643.2258.15362632812220627446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170725235512.GC23846@kernel.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Jul 2017 17:03:23 -0700
Message-ID: <CAPcyv4g1V=1E-cOzHabZswwVGmJGQUNSYxnSyOtwxo79eRYyNw@mail.gmail.com>
Subject: Re: [PATCH 3/4] ndctl: switch to tools/include/linux/{kernel, list,
 bitmap}.h
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 25, 2017 at 4:55 PM, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
> Em Tue, Jul 25, 2017 at 03:36:26PM -0700, Dan Williams escreveu:
>> Replace the ccan implementation of list primitives, bitmap helpers and
>> small utility macros with the common definitions available in
>> tool/include/linux.
>
> You should first add what you need in separate patches, paving the way
> to then use it, and some stuff are already there, see below:

Ok, I'll break out those changes separately.

>
>> diff --git a/tools/include/linux/hashtable.h b/tools/include/linux/hashtable.h
>> index c65cc0aa2659..251eabf2a05e 100644
>> --- a/tools/include/linux/hashtable.h
>> +++ b/tools/include/linux/hashtable.h
>> @@ -13,10 +13,6 @@
>>  #include <linux/hash.h>
>>  #include <linux/log2.h>
>>
>> -#ifndef ARRAY_SIZE
>> -#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
>> -#endif
>> -
>
> This is already tools/include/linux/kernel.h as
>
> #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>
> It was moved by:
>
> commit 68289cbd83eaa20faef7cc818121bc8e769065de
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Mon Apr 17 12:01:36 2017 -0300
>
>     tools include: Drop ARRAY_SIZE() definition from linux/hashtable.h
>
>     As tools/include/linux/kernel.h has it now, with the goodies present in
>     the kernel.h counterpart, i.e. checking that the parameter is an array
>     at build time.
>
> --------------------
>
>
>>  #define DEFINE_HASHTABLE(name, bits)                                         \
>>       struct hlist_head name[1 << (bits)] =                                   \
>>                       { [0 ... ((1 << (bits)) - 1)] = HLIST_HEAD_INIT }
>> diff --git a/tools/include/linux/kernel.h b/tools/include/linux/kernel.h
>> index 28607db02bd3..ebe5211ce086 100644
>> --- a/tools/include/linux/kernel.h
>> +++ b/tools/include/linux/kernel.h
>> @@ -45,6 +45,10 @@
>>       _min1 < _min2 ? _min1 : _min2; })
>>  #endif
>>
>> +#ifndef clamp
>> +#define clamp(v, f, c) (max(min((v), (c)), (f)))
>> +#endif
>> +
>
> The include/linux/kernel.h definition is:
>
>
> /**
>  * clamp - return a value clamped to a given range with strict typechecking
>  * @val: current value
>  * @lo: lowest allowable value
>  * @hi: highest allowable value
>  *
>  * This macro does strict typechecking of lo/hi to make sure they are of the
>  * same type as val.  See the unnecessary pointer comparisons.
>  */
> #define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
>
> I suggest we try to track the kernel counterparts as much as possible, and
> put the definitions in the same order as in the kernel header, this way we
> can even look at how different they are using plain old 'diff'.

Sounds good.

>
>>  #ifndef roundup
>>  #define roundup(x, y) (                                \
>>  {                                                      \
>> @@ -54,6 +58,10 @@
>>  )
>>  #endif
>>
>> +#ifndef ARRAY_SIZE
>> +#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
>> +#endif
>> +
>>  #ifndef BUG_ON
>>  #ifdef NDEBUG
>>  #define BUG_ON(cond) do { if (cond) {} } while (0)
>> @@ -66,8 +74,10 @@
>>   * Both need more care to handle endianness
>>   * (Don't use bitmap_copy_le() for now)
>>   */
>> +#ifndef cpu_to_le64
>>  #define cpu_to_le64(x)       (x)
>>  #define cpu_to_le32(x)       (x)
>> +#endif
>
> This will not apply, there were changes here as well.

I should have mentioned that this tree was based on 4.10. I picked an
old merge base on the thought that it would reduce the chance of
people bisecting 4.13..4.14-rc1 ending up in the initial ndctl history
where only tools/ndctl/ exists. But, if I want to touch kernel.h this
old baseline is not going to work...

I'll play around with git bisect to see if the old merge base is
actually worth it, and roll forward otherwise.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
