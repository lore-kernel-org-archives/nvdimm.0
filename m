Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:222:6c9::f5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 62E7E21107172
 for <linux-nvdimm@lists.01.org>; Wed,  5 Sep 2018 12:22:13 -0700 (PDT)
Date: Wed, 5 Sep 2018 21:22:11 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [RFC] UAPI: Check headers by compiling all together as C++
In-Reply-To: <20180905165552.GB25206@kroah.com>
Message-ID: <nycvar.YFH.7.76.1809052120510.24932@n3.vanv.qr>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
 <20180905165552.GB25206@kroah.com>
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
To: Greg KH <greg@kroah.com>
Cc: moderated for non-subscribers <alsa-devel@alsa-project.org>, "Michael S. Tsirkin" <mst@redhat.com>, David Airlie <airlied@linux.ie>, Jason Wang <jasowang@redhat.com>, Mat Martineau <mathew.j.martineau@linux.intel.com>, dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org, David Howells <dhowells@redhat.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, keyrings@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-nvdimm@lists.01.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, coreteam@netfilter.org, Kent Overstreet <kent.overstreet@gmail.com>, linux-kbuild@vger.kernel.org, linux-arm-msm@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>, Jan Harkes <jaharkes@cs.cmu.edu>, Michal Marek <michal.lkml@markovi.net>, linux-api@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>, netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org, freedreno@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

On Wednesday 2018-09-05 18:55, Greg KH wrote:

>On Wed, Sep 05, 2018 at 04:54:27PM +0100, David Howells wrote:
>> 
>> Here's a set of patches that inserts a step into the build process to make
>> sure that the UAPI headers can all be built together with C++ (if the
>> compiler being used supports C++).  All but the final patch perform fixups,
>> including:
>
>Wait, why do we care?  What has recently changed to start to directly
>import kernel uapi files into C++ code?

With C++11, C++ has become a much nicer language to use (for userspace, anyway).

>And if userspace wants to do this, can't they do the C namespace trick
>themselves when they do the import?

The only trick is to use an extra C source file and extensively wrap things.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
