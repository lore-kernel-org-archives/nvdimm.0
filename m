Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D36BA21A04839
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 06:31:26 -0700 (PDT)
Date: Fri, 31 Mar 2017 15:31:23 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 0/3] apci, nfit: DSM improvements
Message-ID: <20170331133123.GC3848@linux-x5ow.site>
References: <cover.1488921944.git.linda.knippers@hpe.com>
 <20170331090135.GB3848@linux-x5ow.site> <58DE5755.1090900@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <58DE5755.1090900@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Linda Knippers <linda.knippers@hpe.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 31, 2017 at 09:19:17AM -0400, Linda Knippers wrote:
> On 03/31/2017 05:01 AM, Johannes Thumshirn wrote:
> > On Tue, Mar 07, 2017 at 04:35:11PM -0500, Linda Knippers wrote:
> >> The first two patches in this series are motivated by feedback
> >> from distribution developers, test engineers, and management tool
> >> developers.  We need the ability to test and support Linux and
> >> management tools on systems that support more than one DSM family
> >> for NVDIMM-N.
> >>
> >> We also need the ability to test and support new functions without
> >> requiring users to update their kernel.  These changes will also
> >> facilate development as we move toward DSM standardization.
> >> The ability to restrict DSM functions to the currently documented
> >> set is still in place.
> >>
> >> The third patch cleans up a cosmetic/modinfo parsing issue with one
> >> of the existing module parameters.
> > =

> > Hi Linda and Dan,
> > =

> > Can you tell me the status of this series? I haven't seen it in Dan's
> > tree and can't remember a reason why it's not merged.
> =

> I assume/hope it's just waiting for the next merge window.
> At this point I think Dan is just pulling in critical fixes.
> If there's some other reason, I'd like to hear about it too.

OK.

Dan is it possible to do a for-next branch or a for-4.12 branch?
That'll make my life a _much_ easier.

Thanks,
	Johanens

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
