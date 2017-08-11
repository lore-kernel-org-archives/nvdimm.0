Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x233.google.com (mail-yw0-x233.google.com
 [IPv6:2607:f8b0:4002:c05::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C482321D490E5
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 21:08:54 -0700 (PDT)
Received: by mail-yw0-x233.google.com with SMTP id p68so16187262ywg.0
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 21:11:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170811034122.GA19484@anatevka.americas.hpqcorp.net>
References: <20170811000000.18672-1-jerry.hoemann@hpe.com>
 <CAPcyv4grN7RXfkxNfXad79FAKJzwrAxit-xXW4J7n22i-s+Dvg@mail.gmail.com>
 <20170811021221.GA19197@anatevka.americas.hpqcorp.net>
 <CAPcyv4hAkqTZe-NnyQ7xFPjNg2aw8ob06ppfg_tDx-bywOHvAw@mail.gmail.com>
 <20170811034122.GA19484@anatevka.americas.hpqcorp.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Aug 2017 21:11:13 -0700
Message-ID: <CAPcyv4gJfZG4_TvNGkq-tM74BrL2MDJgZCb7R5Cof81PJC3TPQ@mail.gmail.com>
Subject: Re: [PATCH] ndctl: New structure definitions.
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 10, 2017 at 8:41 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Thu, Aug 10, 2017 at 07:27:58PM -0700, Dan Williams wrote:
>> On Thu, Aug 10, 2017 at 7:12 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> > On Thu, Aug 10, 2017 at 05:47:10PM -0700, Dan Williams wrote:
>> >> On Thu, Aug 10, 2017 at 5:00 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> >> > Add structure definitions newly published/modified in v0.85:
>> >> >
>> >> > https://github.com/HewlettPackard/hpe-nvm/blob/master/Documentation/NFIT_DSM_DDR4_NVDIMM-N_v85.pdf
>> >>
>> >> Are there going to be follow-on patches that make use of these
>> >> definitions? I would save this update for when those follow-on patches
>> >> are ready.
>> >
>> > There are multiple projects both inside and outside of HPE that need to
>> > make DSM calls.
>> >
>> > The DSM ioctl is an interface exported to user applications.  Customers
>> > and vendors can and will use this interface for their own tools and this
>> > use need not result in patches sent back to the ndctl project.
>>
>> My hope was that the existing extra definitions in ndctl-hpe1.h would
>> gain some users at some point in the future, but there's otherwise no
>> need to add dead code to ndctl-hpe1.h. That header is only used at
>> compile time it's not shipped so it doesn't provide any benefit to
>> those third party applications that you mention.
>
> AFAIK ndctl-hpe1.h is the only "upstream" place where the definition of
> the HPE1 non-root function structures reside.

For a third-party utility I don't see how ndctl is its upstream.

>
> Having the definitions in the kernel supplied header ndctl.h would be
> much better, but you pushed back on that two years ago.
>
> Have you changed your mind?  Do you want me to add the HPE nvdimm-n
> non root structure definitions to ndctl.h like the Intel non-root
> definitions?

No, they don't do the kernel any good either. ND_CMD_CALL is meant to
be the last of the ioctl payload definitions we need to add to
ndctl.h.

For these to be useful to the ndctl utilty they need libndctl.h
wrappers similar to what we've done for handling SMART payloads across
vendors. I.e. hide the vendor-specific aspect and make a generic
interface. For example, these commands seem to have several
similarities with the Microsoft format. I'm planning to do the same
with new additions to the Intel DSM command set.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
