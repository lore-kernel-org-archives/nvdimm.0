Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <20160629153114.4bbvee5zftre2lcc@c203.arch.suse.de>
References: <20160628082257.4z6tfucszvebhzus@c203.arch.suse.de>
 <CAPcyv4gH32tGM-YHVYwm1FuNp9GAerOKjpoPS6eAwNVZberPPQ@mail.gmail.com>
 <57732FB2.8010408@redhat.com>
 <CAPcyv4ihATMhz9YK_zs1krakENJxrumHrGP=GP-01NXSSRuXqA@mail.gmail.com>
 <20160629153114.4bbvee5zftre2lcc@c203.arch.suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Jun 2016 16:47:26 -0700
Message-ID: <CAPcyv4h4UZ2TXaBXXEFt3NFq2c0z3JwRsQJLteDsZGZq97Yeug@mail.gmail.com>
Subject: Re: test suite errors
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 29, 2016 at 8:31 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Tue, Jun 28, 2016 at 07:24:17PM -0700, Dan Williams wrote:
>> On Tue, Jun 28, 2016 at 7:17 PM, yizhan <yizhan@redhat.com> wrote:
>> > On 06/29/2016 12:26 AM, Dan Williams wrote:
>> >> Do you have CONFIG_DEV_DAX_PMEM=m?
>> >>
>> > I also met this error with CONFIG_DEV_DAX_PMEM=m
>> > Detailed log I have post at the last comment at
>> > https://github.com/pmem/ndctl/issues/3
>>
>> Can you re-run the test with kernel debugging enabled and piping the
>> test messages to the kernel buffer.
>>
>> Add the following to the kernel command line:
>>
>>     libnvdimm.dyndbg nfit.dyndbg nd_pmem.dyndbg nd_btt.dyndbg
>> dax_pmem.dyndbg dax.dyndbg
>>
>> Specify add --enable-test when configuring ndctl and then run:
>>
>>     ndctl test 2>/dev/kmsg
>>
>> ...and send the log?
>
> Here's the log. I did a dmesg -C to clear off all old stuff beforehand.
>
> Thanks for looking into it.
>
>
[..]
> [ 2738.166571] nd dax13.0: align_store: result: 0 wrote: 2097152
[..]
> [ 2738.166691] dax_pmem dax13.0: bad offset: 0x100000 dax disabled
> [ 2738.166694]  ndbus1: dax_pmem.probe(dax13.0) = -6
> [ 2738.166802] libndctl: ndctl_dax_enable: dax13.0: failed to enable
> [ 2738.166820] dax13.0: expected dax enable success, region13 read-write
> [ 2738.166825] namespace13.0: failed to create dax
> [ 2738.166828] namespace13.0: failed to configure namespace
> [ 2738.166835] ndctl-test0 failed: -6

I think there is variability in the alignment of the DMA_CMA start
address from system-to-system which is why the test is passing for me.

The recent changes to the dax unit tests [1] [2] prevent this failure
by moving higher order dax / pfn testing to a memmap=ss!nn
configuration instead of nfit_test.

Specifically I think we are failing because the configuration needs
the allocation to be "2097152" (2MB) aligned, but it randomly ends up
on a 1MB alignment.

[1]: https://patchwork.kernel.org/patch/9199771/
[2]: https://patchwork.kernel.org/patch/9196641/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
