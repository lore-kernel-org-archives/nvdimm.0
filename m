Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com [47.88.44.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77562C80
	for <nvdimm@lists.linux.dev>; Fri, 26 Nov 2021 03:11:55 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=escape@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0UyKa6Q4_1637896296;
Received: from 30.225.28.93(mailfrom:escape@linux.alibaba.com fp:SMTPD_---0UyKa6Q4_1637896296)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 26 Nov 2021 11:11:37 +0800
Message-ID: <020e6b6c-55ba-2079-7720-bd9dbb1bf335@linux.alibaba.com>
Date: Fri, 26 Nov 2021 11:11:36 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH V7 05/18] x86/pks: Add PKS setup code
To: Thomas Gleixner <tglx@linutronix.de>, ira.weiny@intel.com,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Dan Williams <dan.j.williams@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Fenghua Yu <fenghua.yu@intel.com>,
 "Hansen, Dave" <dave.hansen@intel.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-mm@kvack.org
References: <20210804043231.2655537-1-ira.weiny@intel.com>
 <20210804043231.2655537-6-ira.weiny@intel.com> <87ilwgl10a.ffs@tglx>
From: "taoyi.ty" <escape@linux.alibaba.com>
In-Reply-To: <87ilwgl10a.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/21 11:15 PM, Thomas Gleixner wrote:
> On Tue, Aug 03 2021 at 21:32, ira weiny wrote:
>> +#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
>> +
>> +void setup_pks(void);
> 
> pks_setup()
> 
>> +#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
>> +
>> +static DEFINE_PER_CPU(u32, pkrs_cache);
>> +u32 __read_mostly pkrs_init_value;
>> +
>> +/*
>> + * write_pkrs() optimizes MSR writes by maintaining a per cpu cache which can
>> + * be checked quickly.
>> + *
>> + * It should also be noted that the underlying WRMSR(MSR_IA32_PKRS) is not
>> + * serializing but still maintains ordering properties similar to WRPKRU.
>> + * The current SDM section on PKRS needs updating but should be the same as
>> + * that of WRPKRU.  So to quote from the WRPKRU text:
>> + *
>> + *     WRPKRU will never execute transiently. Memory accesses
>> + *     affected by PKRU register will not execute (even transiently)
>> + *     until all prior executions of WRPKRU have completed execution
>> + *     and updated the PKRU register.
>> + */
>> +void write_pkrs(u32 new_pkrs)
> 
> pkrs_write()
> 
>> +{
>> +	u32 *pkrs;
>> +
>> +	if (!static_cpu_has(X86_FEATURE_PKS))
>> +		return;
> 
>    cpu_feature_enabled() if at all. Why is this function even invoked
>    when PKS is off?
> 
>> +
>> +	pkrs = get_cpu_ptr(&pkrs_cache);
> 
> As far as I've seen this is mostly called from non-preemptible
> regions. So that get/put pair is pointless. Stick a lockdep assert into
> the code and disable preemption at the maybe one callsite which needs
> it.
> 
>> +	if (*pkrs != new_pkrs) {
>> +		*pkrs = new_pkrs;
>> +		wrmsrl(MSR_IA32_PKRS, new_pkrs);
>> +	}
>> +	put_cpu_ptr(pkrs);
>> +}
>> +
>> +/*
>> + * Build a default PKRS value from the array specified by consumers
>> + */
>> +static int __init create_initial_pkrs_value(void)
>> +{
>> +	/* All users get Access Disabled unless changed below */
>> +	u8 consumer_defaults[PKS_NUM_PKEYS] = {
>> +		[0 ... PKS_NUM_PKEYS-1] = PKR_AD_BIT
>> +	};
>> +	int i;
>> +
>> +	consumer_defaults[PKS_KEY_DEFAULT] = PKR_RW_BIT;
>> +
>> +	/* Ensure the number of consumers is less than the number of keys */
>> +	BUILD_BUG_ON(PKS_KEY_NR_CONSUMERS > PKS_NUM_PKEYS);
>> +
>> +	pkrs_init_value = 0;
> 
> This needs to be cleared because the BSS might be non zero?
> 
>> +	/* Fill the defaults for the consumers */
>> +	for (i = 0; i < PKS_NUM_PKEYS; i++)
>> +		pkrs_init_value |= PKR_VALUE(i, consumer_defaults[i]);
> 
> Also PKR_RW_BIT is a horrible invention:
> 
>> +#define PKR_RW_BIT 0x0
>>   #define PKR_AD_BIT 0x1
>>   #define PKR_WD_BIT 0x2
>>   #define PKR_BITS_PER_PKEY 2
> 
> This makes my brain spin. How do you fit 3 bits into 2 bits per key?
> That's really non-intuitive.
> 
> PKR_RW_ENABLE		0x0
> PKR_ACCESS_DISABLE	0x1
> PKR_WRITE_DISABLE	0x2
> 
> makes it obvious what this is about, no?
> 
> Aside of that, the function which set's up the init value is really
> bogus. As you explained in the cover letter a kernel user has to:
> 
>     1) Claim an index in the enum
>     2) Add a default value to the array in that function
> 
> Seriously? How is that any better than doing:
> 
> #define PKS_KEY0_DEFAULT	PKR_RW_ENABLE
> #define PKS_KEY1_DEFAULT	PKR_ACCESS_DISABLE
> ...
> #define PKS_KEY15_DEFAULT	PKR_ACCESS_DISABLE
> 
> and let the compiler construct pkrs_init_value?
> 
> TBH, it's not and this function has to be ripped out in case that you
> need a dynamic allocation of keys some day. So what is this buying us
> aside of horrible to read and utterly pointless code?
> 
>> +	return 0;
>> +}
>> +early_initcall(create_initial_pkrs_value);
>> +
>> +/*
>> + * PKS is independent of PKU and either or both may be supported on a CPU.
>> + * Configure PKS if the CPU supports the feature.
>> + */
>> +void setup_pks(void)
>> +{
>> +	if (!cpu_feature_enabled(X86_FEATURE_PKS))
>> +		return;
>> +
>> +	write_pkrs(pkrs_init_value);
> 
> Is the init value set up _before_ this function is invoked for the first
> time?
> 
> Thanks,
> 
>          tglx
> 
Setting up for cpu0 is before create_initial_pkrs_value. therefore pkrs 
value of cpu0 won't be set correctly.

[root@AliYun ~]# rdmsr -a 0x000006E1
0
55555554
55555554
55555554
55555554
55555554
55555554
55555554
55555554
55555554

Here are my test results after applying the patches

Thanks.
