Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from s-opensource.com
 (ec2-52-27-115-49.us-west-2.compute.amazonaws.com [52.27.115.49])
 by ml01.01.org (Postfix) with ESMTP id 11B8E1A1E4F
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 06:59:53 -0700 (PDT)
Date: Wed, 19 Oct 2016 11:59:18 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 34/37] docs: fix locations of several documents that
 got moved
Message-ID: <20161019115918.1162d16e@vento.lan>
In-Reply-To: <20161019103442.GD1461@amd>
References: <cover.1476801354.git.mchehab@s-opensource.com>
 <28c1f5d3867174a7017e3f3d9e9e4ebb096ceed8.1476801354.git.mchehab@s-opensource.com>
 <20161019103442.GD1461@amd>
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
To: Pavel Machek <pavel@ucw.cz>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Jaroslav Kysela <perex@perex.cz>, Chris Metcalf <cmetcalf@ezchip.com>, Peter Loeffler <peter.loeffler@guruz.at>, Finn Thain <fthain@telegraphics.com.au>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Jakub Wilk <jwilk@jwilk.net>, linux-acpi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>, Jean Delvare <jdelvare@suse.com>, linux-pm@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Karsten Keil <isdn@linux-pingi.de>, Jiri Kosina <jkosina@suse.cz>, "seokhoon.yoon" <iamyooon@gmail.com>, Li Zefan <lizefan@huawei.com>, Ryan Swan <ryan@ryanswan.com>, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, Mark Rutland <mark.rutland@arm.com>, alsa-devel@alsa-project.org, Manohar Vanga <manohar.vanga@gmail.com>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, "=?UTF-8?B?w5h5dmluZA==?= A. Holm" <sunny@sunbase.org>, virtualization@lists.linux-foundation.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Yuan Sun <sunyuan3@huawei.com>, Wim Van Sebroeck <wim@iguana.be>, Harry Wei <harryxiyou@gmail.com>, Shuah Khan <shuah@kernel.org>, Philippe Loctaux <phil@philippeloctaux.com>, linux-watchdog@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Harald Welte <laforge@gnumonks.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Borislav Petkov <bp@suse.de>, Wolfgang Grandegger <wg@grandegger.com>, Len Brown <lenb@kernel.org>, Haosdent Huang <haosdent@gmail.com>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Tejun Heo <tj@kernel.org>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, linux-can@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Steffen Klassert <klassert@mathematik.tu-chemnitz.de>, Tomeu Vizoso <tomeu.vizoso@collabora.com>, Oliver Neukum <oneukum@suse.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Minchan Kim <minchan@kernel.org>, Daniel Bristot de Oliveira <bristot@redhat.com>, Thomas Garnier <thgarnie@google.com>, linux-wireless@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-fbdev@vger.kernel.org, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-kselftest@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, "Michael S. Tsirkin" <mst@redhat.com>, Greg Hackmann <ghackmann@google.com>, Diego Viola <diego.viola@gmail.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Thomas Gardner <tmg@fastmail.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ben Hutchings <ben@decadent.org.uk>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Li RongQing <roy.qing.li@gmail.com>, Egor Uleyskiy <egor.ulieiskii@gmail.com>, SeongJae Park <sj38.park@gmail.com>, Andy Whitcroft <apw@canonical.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-hwmon@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Wei Jiangang <weijg.fnst@cn.fujitsu.com>, Martyn Welch <martyn@welchs.me.uk>, Askar Safin <safinaskar@mail.ru>, linux-kernel@zh-kernel.org, Colin Cross <ccross@android.com>, linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org, Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Takashi Iwai <tiwai@suse.com>, Masanari Iida <standby24x7@gmail.com>, linux-ide@vger.kernel.org, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Yang Shi <yang.shi@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>, devel@driverdev.osuosl.org, Markus Heiser <markus.heiser@darmarIT.de>, Darren Hart <dvhart@linux.intel.com>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, devicetree@vger.kernel.org, rtc-linux@googlegroups.com, Arnaldo Carvalho de Melo <acme@redhat.com>, linux-nvdimm@lists.01.org, Rob Herring <robh+dt@kernel.org>, Marc Kleine-Budde <mkl@pengutronix.de>, Hannes Reinicke <hare@suse.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Dmitry Vyukov <dvyukov@google.com>, Jens Axboe <axboe@kernel.dk>, Alessandro Zummo <a.zummo@towertech.it>, Doug Smythies <doug.smythies@gmail.com>, netdev@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Paolo Bonzini <pbonzini@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, Manuel =?UTF-8?B?UMOpZ291cmnDqS1Hb25uYXJk?= <mpg@elzevir.fr>
List-ID: <linux-nvdimm@lists.01.org>

Em Wed, 19 Oct 2016 12:34:42 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
> 
> 
> > --- a/Documentation/ABI/testing/sysfs-kernel-slab
> > +++ b/Documentation/ABI/testing/sysfs-kernel-slab
> > @@ -347,7 +347,7 @@ Description:
> >  		because of fragmentation, SLUB will retry with the minimum order
> >  		possible depending on its characteristics.
> >  		When debug_guardpage_minorder=N (N > 0) parameter is specified
> > -		(see Documentation/kernel-parameters.txt), the minimum possible
> > +		(see Documentation/admin-guide/kernel-parameters.rst), the minimum possible
> >  		order is used and this sysfs entry can not be used to change
> >  		the order at run time.  
> 
> Dunno, but kernel-parameters.txt was already quite long... for a file
> that is referenced quite often. Adding admin-guide/ into the path does
> not really help.

The big string name starts with Documentation/ :) There are some discussions 
about changing it to doc/ (or docs/). Also, as you said, kernel-parameters
is already a big name. Perhaps we could use, instead, "kernel-parms".

If we rename kernel-parameters.rst to kernel-parms.rst, plus the doc/ rename,
then the string size will actually reduce:

-		(see Documentation/kernel-parameters.txt), the minimum possible
+		(see doc/admin-guide/kernel-parms.rst), the minimum possible

> Maybe admin-guide should go directly into Documentation/ , as that's
> what our users are interested in?

There are several problems if we keep them at Documentation/ dir:

- We'll end by mixing documents already converted to ReST with documents
  not converted yet;

- A rename is needed anyway, as Sphinx only accepts ReST files that end
  with the extension(s) defined at Documentation/conf.py (currently,
  .rst);

- A partial documentation build is made by sub-directory. If we put
  files under /Documentation, there's no way to build just one
  book.

> Plus, I'm not sure how many developers will figure out that process/
> is what describes kernel patch submission process. We have processes
> in the kernel, after all...

Do you have a better idea?

> Could we leave symlinks in place? 

My initial patch did that. It created symlinks on the
Documentation/user (with was the previous name for the admin's guide).

The big issue is how to identify what files at Documentation/ that
were not converted yet.

On this patch series, we opted to move the file and keep just a
reference to the most relevant ones, pointing to the new location:
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=lkml-books-v2&id=217462c76ee1c12b45750723059a3461018b6975
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=lkml-books-v2&id=d15595a318356804ed1bc42f509e72de9d031513

We could do something similar to Documentation/kernel-parameters.txt.
Yet, the best is, IMHO, to keep this on the absolute minimum of files,
as it also makes harder to identify what txt files still require conversion.

> People say "please follow
> CodingStyle" when reviewing patches. Saying "please follow
> process/conding-style.rst" ... somehow I don't think that's going to
> happen.

As we have a Documentation/CodingStyle (pointing to the new location),
this should still work. 

That's said, using my maintainer's hat, when I review patches from a newbie,
I actually prefer to point them to some location with the current
practices, as they usually don't know much about the Kernel's way to
receive patch. So, I reply with something like:

	"Please read this:
		https://mchehab.fedorapeople.org/kernel_docs/process/index.html
	 with instructions about how to submit your work"

For an old contributor, I just say: "please follow the coding style" 
or I reply with the output of checkpatch.pl.

Maybe it is just me, but I very much prefer to point to some URL with
everything packed altogether than to do several reviews until someone
RTFM (Read The Fine Manual), and starts to submit it right.

Thanks,
Mauro
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
