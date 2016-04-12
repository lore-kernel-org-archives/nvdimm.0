Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x22a.google.com (mail-lf0-x22a.google.com
 [IPv6:2a00:1450:4010:c07::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 318011A214B
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 17:27:25 -0700 (PDT)
Received: by mail-lf0-x22a.google.com with SMTP id e190so3215889lfe.0
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 17:27:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160412001937.GE119165@tevye.fc.hp.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
 <fc6407acd4f88fad4a74d1be19bc46de01f0d809.1458583367.git.jerry.hoemann@hpe.com>
 <CAPcyv4g-zgOoCBcm7M0Sgb8uM6pOC2Aott-yk-jHtU+zQs6smw@mail.gmail.com>
 <20160411231657.GB119165@tevye.fc.hp.com>
 <CAPcyv4g8BLp=oQhENAHeHaD0w5=vqu_xHXkXFbBE+xLJ64ohSA@mail.gmail.com>
 <20160412001937.GE119165@tevye.fc.hp.com>
Date: Mon, 11 Apr 2016 17:27:23 -0700
Message-ID: <CAPcyv4jjxdgj04JHPGzxVw3zGAHWJfsFDHMik-XbX2sLPfhE=w@mail.gmail.com>
Subject: Re: [PATCH v8 02/10] nvdimm: Add wrapper for IOCTL pass thru
From: Dan Williams <dan.j.williams@intel.com>
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

On Mon, Apr 11, 2016 at 5:19 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Mon, Apr 11, 2016 at 04:23:55PM -0700, Dan Williams wrote:
>> On Mon, Apr 11, 2016 at 4:16 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> > On Mon, Apr 11, 2016 at 11:21:45AM -0700, Dan Williams wrote:
>> >> On Mon, Mar 21, 2016 at 12:37 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> >> > +
>> >> > +/*
>> >> > + * the list nd_family of commands.  The mapping to firmware handles
>> >> > + * is definied in the nfit_cmd_family_tbl
>> >> > + *
>> >> > + */
>> >> > +#define ND_TYPE_BUS                    1
>> >> > +#define ND_TYPE_DIMM_INTEL1            2
>> >> > +#define ND_TYPE_DIMM_N_HPE1            3
>> >> > +#define ND_TYPE_DIMM_N_HPE2            4
>> >> > +
>> >> > +
>> >> > +#define ND_IOCTL_CALL                  _IOWR(ND_IOCTL, ND_CMD_CALL,\
>> >> > +                                       struct nd_cmd_pkg)
>> >> > +
>> >> > +
>> >> > +
>> >> >  #endif /* __NDCTL_H__ */
>> >>
>> >> Looks, good, but for now lets assume there will never be such a thing
>> >> as ND_TYPE_BUS commands or an ND_CMD_CALL for the bus.  I.e. all the
>> >> commands that currently exist for the bus are commands that the kernel
>> >> wants to handle.  In this way, struct nd_cmd_pkg is a solution to the
>> >> problem of commands that the kernel knows exist, but has no use case
>> >> to generate or parse itself.  Commands that fit that description
>> >> currently only exist in leaf node implementations.
>> >
>> >
>> > Would user space application ever want to call commands for the bus?
>> >
>> > I assume the answer is yes, as there are ioctls for ND_CMD_ARS_CAP, etc.,
>> >
>> > My thoughts here was to make the pass thru uniform, capable of calling
>> > all the dsm functions that a user space agent might want to call.   I.e
>> > don't make user call some _DSM functions one way, and other DSM function
>> > another way....
>> >
>>
>> Indeed that would have been nice had that been the implementation from
>> the beginning, but binaries using the current more verbose interface
>> are already shipping in distributions.  So, the train has already left
>
> This doesn't break existing binaries. They will still work.
>
> I'm looking at the world going forward.  :)

Sure, but I can't delete the old stuff, so adding a parallel
submission path adds maintenance overhead that overshadows the
benefit.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
