Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E72F2111B78D
 for <linux-nvdimm@lists.01.org>; Wed,  5 Sep 2018 10:43:06 -0700 (PDT)
Date: Wed, 5 Sep 2018 13:42:58 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC] UAPI: Check headers by compiling all together as C++
Message-ID: <20180905133711-mutt-send-email-mst@kernel.org>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
 <20180905165552.GB25206@kroah.com>
 <a1efae8d26cc5b73b180e9521d6b62590c55aa86.camel@opteya.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a1efae8d26cc5b73b180e9521d6b62590c55aa86.camel@opteya.com>
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
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: moderated for non-subscribers <alsa-devel@alsa-project.org>, David Airlie <airlied@linux.ie>, Greg KH <greg@kroah.com>, Jason Wang <jasowang@redhat.com>, Mat Martineau <mathew.j.martineau@linux.intel.com>, dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org, David Howells <dhowells@redhat.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, keyrings@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-nvdimm@lists.01.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, coreteam@netfilter.org, Kent Overstreet <kent.overstreet@gmail.com>, linux-kbuild@vger.kernel.org, linux-arm-msm@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>, Jan Harkes <jaharkes@cs.cmu.edu>, Michal Marek <michal.lkml@markovi.net>, linux-api@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>, netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org, freedreno@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 05, 2018 at 07:33:38PM +0200, Yann Droneaud wrote:
> Hi,
> =

> Le mercredi 05 septembre 2018 =E0 18:55 +0200, Greg KH a =E9crit :
> > On Wed, Sep 05, 2018 at 04:54:27PM +0100, David Howells wrote:
> > > =

> > > Here's a set of patches that inserts a step into the build process to=
 make
> > > sure that the UAPI headers can all be built together with C++ (if the
> > > compiler being used supports C++).  All but the final patch perform f=
ixups,
> > > including:
> > =

> > Wait, why do we care?  What has recently changed to start to directly
> > import kernel uapi files into C++ code?
> > =

> > And if userspace wants to do this, can't they do the C namespace trick
> > themselves when they do the import?  That must be how they are doing it
> > today, right?
> > =

> =

> They can't.
> =

> =

> Adding extern "C" { } doesn't magically make "class" a non keyword.
> Even if it was the case, writing C++ code using whatever->class would
> probably broke because class is a keyword in C++.

I think it's a bug in the language TBH.

> -- =

> Yann Droneaud
> OPTEYA
> =

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
