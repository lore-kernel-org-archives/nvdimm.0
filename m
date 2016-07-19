Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 507D81A1E25
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 15:54:20 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id w18so47155576oiw.3
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 15:53:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160719224644.GJ140413@tevye.fc.hp.com>
References: <146679026571.24395.11569929364936343871.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160719171153.GA121461@tevye.fc.hp.com>
 <cfd9968d-9835-0ef1-fafd-54fd3b892d1c@hpe.com>
 <CAPcyv4gqmjMFveV+iE2NbvWnTb5kdy8w54VDgLYxeMJ5NJyzbw@mail.gmail.com>
 <CAPcyv4hbyq7MVQrTxYixo+fP7R=wV-Nt84NNfVJKrYWwUSJg=Q@mail.gmail.com>
 <20160719224644.GJ140413@tevye.fc.hp.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Jul 2016 15:53:28 -0700
Message-ID: <CAPcyv4g1+RPCMqSLY6daYATkEvRVRre=KkKeu25L9jQOsMjjiQ@mail.gmail.com>
Subject: Re: [PATCH] acpi,
 nfit: fix acpi_check_dsm() vs zero functions implemented
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
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Marvin Spinhirne <spin@hpe.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 19, 2016 at 3:46 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Tue, Jul 19, 2016 at 01:01:16PM -0700, Dan Williams wrote:
>> On Tue, Jul 19, 2016 at 11:52 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> > On Tue, Jul 19, 2016 at 11:50 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> >> On 7/19/2016 1:11 PM, Jerry Hoemann wrote:
>> [..]
>> >>> As nfit_mem->family always equals NVDIMM_FAMILY_INTEL, no subsequent
>> >>> DSM call will succeed for NVDIMM_FAMILY_HPE1 or any other
>> >>> family.
>> >>>
>> >>> I don't have a fix as of yet, but wanted to make you aware of
>> >>> the problem.
>> >>
>> >> Could we try the all known UUIDs looking for one that returns a non-zero
>> >> value?
>> >>
>> >
>> > Yes, that seems like the way forward, and also make not finding a DSM
>> > family non-fatal.
>>
>> Actually, all we need is that last bit...  Jerry, Xiao, can you try
>> the attached patch on top for v4.7-rc6 to see if it works in both HPe
>> and QEMU 2.6 environments respectively?
>
> Dan,
>
> I applied this patch on top of the SLES 12 sp2 kernel I was testing
> with last night.
>
> The proposed patch below works for HPE nvdimms.

Thanks Jerry, I'll add your Tested-by and push it for v4.7-final after
Xiao has a chance to confirm.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
