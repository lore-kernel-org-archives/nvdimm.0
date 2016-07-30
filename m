From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG] kernel NULL pointer dereference observed during pmem btt
 switch test
Date: Sat, 30 Jul 2016 08:52:23 -0700
Message-ID: <CAPcyv4gGLfLbCWmzb5Yt+oVp2pKuGwVv6iY__O_DPmaV__OZDQ@mail.gmail.com>
References: <622794958.9574724.1469674652262.JavaMail.zimbra@redhat.com>
 <1762637089.9575520.1469676013321.JavaMail.zimbra@redhat.com>
 <CAPcyv4g5PpShWfXSV+KPJYW7GFrejUNjk=C1-ak=88iX8XczGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4g5PpShWfXSV+KPJYW7GFrejUNjk=C1-ak=88iX8XczGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, Jul 28, 2016 at 8:50 AM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> [ adding linux-block ]
>
> On Wed, Jul 27, 2016 at 8:20 PM, Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> Hello everyone
>>
>> Could you help check this issue, thanks.
>>
>> Steps I used:
>> 1. Reserve 4*8G of memory for pmem by add kernel parameter "memmap=8G!4G memmap=8G!12G memmap=8G!20G memmap=8G!28G"
>> 2. Execute below script
>> #!/bin/bash
>> pmem_btt_switch() {
>>         sector_size_list="512 520 528 4096 4104 4160 4224"
>>         for sector_size in $sector_size_list; do
>>                 ndctl create-namespace -f -e namespace${1}.0 --mode=sector -l $sector_size
>>                 ndctl create-namespace -f -e namespace${1}.0 --mode=raw
>>         done
>> }
>>
>> for i in 0 1 2 3; do
>>         pmem_btt_switch $i &
>> done
>
> Thanks for the report.  This looks like del_gendisk() frees the
> previous usage of the devt before the bdi is unregistered.  This
> appears to be a general problem with all block drivers, not just
> libnvdimm, since blk_cleanup_queue() is typically called after
> del_gendisk().  I.e. it will always be the case that the bdi
> registered with the devt allocated at add_disk() will still be alive
> when del_gendisk()->disk_release() frees the previous devt number.
>
> I *think* the path forward is to allow the bdi to hold a reference
> against the blk_alloc_devt() allocation until it is done with it.  Any
> other ideas on fixing this object lifetime problem?

Does the attached patch solve this for you?
