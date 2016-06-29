Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: test suite errors
References: <20160628082257.4z6tfucszvebhzus@c203.arch.suse.de>
 <CAPcyv4gH32tGM-YHVYwm1FuNp9GAerOKjpoPS6eAwNVZberPPQ@mail.gmail.com>
 <57732FB2.8010408@redhat.com>
 <CAPcyv4ihATMhz9YK_zs1krakENJxrumHrGP=GP-01NXSSRuXqA@mail.gmail.com>
From: yizhan <yizhan@redhat.com>
Message-ID: <57733777.8010405@redhat.com>
Date: Wed, 29 Jun 2016 10:50:31 +0800
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ihATMhz9YK_zs1krakENJxrumHrGP=GP-01NXSSRuXqA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 06/29/2016 10:24 AM, Dan Williams wrote:
> On Tue, Jun 28, 2016 at 7:17 PM, yizhan <yizhan@redhat.com> wrote:
>> On 06/29/2016 12:26 AM, Dan Williams wrote:
>>> Do you have CONFIG_DEV_DAX_PMEM=m?
>>>
>> I also met this error with CONFIG_DEV_DAX_PMEM=m
>> Detailed log I have post at the last comment at
>> https://github.com/pmem/ndctl/issues/3
> Can you re-run the test with kernel debugging enabled and piping the
> test messages to the kernel buffer.
>
> Add the following to the kernel command line:
>
>      libnvdimm.dyndbg nfit.dyndbg nd_pmem.dyndbg nd_btt.dyndbg
> dax_pmem.dyndbg dax.dyndbg
>
> Specify add --enable-test when configuring ndctl and then run:
>
>      ndctl test 2>/dev/kmsg
>
> ...and send the log?
Sure, will retest it and send the log later this week.

Best Regards
Yi Zhang
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
