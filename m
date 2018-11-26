Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from casper.infradead.org (casper.infradead.org
 [IPv6:2001:8b0:10b:1236::1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DC1DA21106F21
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 03:12:41 -0800 (PST)
Date: Mon, 26 Nov 2018 09:12:29 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [Ksummit-discuss] [RFC PATCH 3/3] libnvdimm, MAINTAINERS:
 Subsystem Profile
Message-ID: <20181126091229.04b5dce0@coco.lan>
In-Reply-To: <8736rwgoem.fsf@intel.com>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
 <20181115061036.1575223d@silica.lan>
 <20181115162008.GO3759@mtr-leonro.mtl.com>
 <CABVU7+twSz3OZx7PTO+bS-wfLfTTjZVhRAnhgtcs6KWwntattw@mail.gmail.com>
 <CAPcyv4hWK+to6vOSfSdeVMDzUutYwg9=XqshSDzaCf0c-u8jLA@mail.gmail.com>
 <20181118110324.543edbd8@coco.lan> <8736rwgoem.fsf@intel.com>
MIME-Version: 1.0
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
To: Jani Nikula <jani.nikula@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ksummit <ksummit-discuss@lists.linuxfoundation.org>, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Jani,

Em Tue, 20 Nov 2018 10:10:25 +0200
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Sun, 18 Nov 2018, Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:
> > Hmm.. Perhaps the subsystem profile should point to IRC channels if any?
> > Several subsystems use them in order to provide newbies some directions
> > and to discuss other development issues.  
> 
> MAINTAINERS:
> 
> 	C: URI for chat protocol, server and channel where developers
> 	   usually hang out, for example irc://server/channel.
> 
> Alas very few subsystems have added that.
> 
> I actually fear very few subsystems will add a subsystem profile for
> that matter.

Sorry for a late reply. In the case of the media subsystem, we
actually use 2 different channels, one when the matter is related
to digital TV (#linuxtv) and another one for the rest (#v4l), both
at freenode.

That's something that wouldn't fit well into MAINTAINERS file, as
we can't explain what should be used for each.

So, the way it is it won't work well for us.

Thanks,
Mauro
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
