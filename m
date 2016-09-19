Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x236.google.com (mail-yw0-x236.google.com
 [IPv6:2607:f8b0:4002:c05::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ADC781A1DF5
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 09:48:32 -0700 (PDT)
Received: by mail-yw0-x236.google.com with SMTP id g192so158343461ywh.1
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 09:48:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9296cdb2-c17e-fac0-2431-c60ffeea6667@intel.com>
References: <147397849629.229288.3348330822830988783.stgit@djiang5-desk3.ch.intel.com>
 <DF4PR84MB016998D3A84119EB743C41F9ABF30@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
 <e85e1839-e80d-b5ba-8b0f-78fe0eaf20bc@intel.com>
 <DF4PR84MB01694C35EF11EA23EE06861CABF50@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
 <9296cdb2-c17e-fac0-2431-c60ffeea6667@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Sep 2016 09:48:31 -0700
Message-ID: <CAPcyv4iz1952Lgg_w=yHOysPdmcNkRvTRwS_c-Tsm_7vNK1v9g@mail.gmail.com>
Subject: Re: [PATCH] ndctl: move test/dax-errors buffer to global to avoid gcc
 optimization
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 19, 2016 at 9:45 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> On 09/18/2016 09:42 AM, Elliott, Robert (Persistent Memory) wrote:
>>
>>
>>> -----Original Message-----
>>> From: Dave Jiang [mailto:dave.jiang@intel.com]
>>> Sent: Friday, September 16, 2016 12:24 PM
>> ...
>>> Subject: Re: [PATCH] ndctl: move test/dax-errors buffer to global to
>>> avoid gcc optimization
>>>
>>> On 09/15/2016 06:18 PM, Elliott, Robert (Persistent Memory) wrote:
>>>>
>> ....
>>>>> Some gcc toolchain are optimizing out the memcpy and this causes
>>>>> dax- errors to not trigger the SIG_BUS when doing memcpy on an
>>>>> mmap'd buffer.  By moving
>>>>> the buffer to a global variable this bypasses the optimization and
>>>>> allow the test to work as intended.
>>>>>
>> ...
>>>>> diff --git a/test/dax-errors.c b/test/dax-errors.c
>>>>> index 11d0031..9ea5c91 100644
>>>>> --- a/test/dax-errors.c
>>>>> +++ b/test/dax-errors.c
>>>>> @@ -17,6 +17,8 @@
>>>>>
>>>>>  static sigjmp_buf sj_env;
>>>>>  static int sig_count;
>>>>> +/* buf is global in order to avoid gcc memcpy optimization */
>>>>> +static void *buf;
>>>>>
>>>>>  static void sigbus_hdl(int sig, siginfo_t *siginfo, void *ptr)
>>>>>  {
>>>>> @@ -27,7 +29,7 @@ static void sigbus_hdl(int sig, siginfo_t *siginfo,
>>>>> void *ptr)
>>>>>
>>>>>  static int test_dax_read_err(int fd)
>>>>>  {
>>>>> -void *base, *buf;
>>>>> +void *base;
>>>>>  int rc = 0;
>>>>>
>>>>>  if (fd < 0) {
>>>>>
>>>>
>>>> I've run into that kind of problem before, and found that
>>>> marking *buf as volatile (and leaving it inside the function)
>>>> tends to be honored better by aggressive optimizing compilers
>>>> and linkers.
>>>
>>> Doesn't appear to work. The compiler discards the volatile.
>>>
>>>
>>>   CC       dax-errors.o
>>> dax-errors.c: In function 'test_dax_read_err':
>>> dax-errors.c:66:9: warning: passing argument 1 of 'memcpy' discards
>>> 'volatile' qualifier from pointer target type [-Wdiscarded-
>>> qualifiers]
>>>   memcpy(buf, base, 4096);
>>>          ^~~
>>> In file included from dax-errors.c:8:0:
>>> /usr/include/string.h:42:14: note: expected 'void * restrict' but
>>> argument is of type 'volatile void *'
>>>  extern void *memcpy (void *__restrict __dest, const void *__restrict
>>> __src,
>>>               ^~~~~~
>>>   CCLD     dax-errors
>>>
>>
>> For this, put volatile to the right of the *:
>> void * volatile buf;
>
> It made the compile warning go away, but it did not prevent the memcpy
> optimization. It still fails unlike when I move the ptr to global.
>
> gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC)
>
> gcc -DHAVE_CONFIG_H -I. -I..  -include ../config.h
> -DSYSCONFDIR=\""/etc"\" -DLIBEXECDIR=\""/usr/libexec"\"
> -DPREFIX=\""/usr"\" -DNDCTL_MAN_PATH=\""/usr/share/man"\" -I../ndctl/lib
> -I../ndctl -I../   -I/usr/include/uuid -I/usr/include/json-c  -Wall
> -Wchar-subscripts -Wformat-security -Wmissing-declarations
> -Wmissing-prototypes -Wnested-externs -Wpointer-arith -Wshadow
> -Wsign-compare -Wstrict-prototypes -Wtype-limits  -fvisibility=hidden
> -ffunction-sections -fdata-sections -g -O2 -MT dax-errors.o -MD -MP -MF
> $depbase.Tpo -c -o dax-errors.o dax-errors.c

I've already applied the "make it global" version.  So we can defer
more "volatile" keyword experiments.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
