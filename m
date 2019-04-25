From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 12/26] compat_ioctl: move more drivers to
 compat_ptr_ioctl
Date: Thu, 25 Apr 2019 17:42:35 +0100
Message-ID: <20190425164235.GT2217@ZenIV.linux.org.uk>
References: <20190416202013.4034148-1-arnd@arndb.de>
 <20190416202701.127745-1-arnd@arndb.de>
 <20190425122153.450fc094@coco.lan>
 <20190425153534.GS2217@ZenIV.linux.org.uk>
 <CAK8P3a2HmiYQJ2FV2FgLiFsD8M9UKteC9Jetx7ja06PQVZWYfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a2HmiYQJ2FV2FgLiFsD8M9UKteC9Jetx7ja06PQVZWYfA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@mellanox.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Sterba <dsterba@suse.com>, Darren Hart <dvhart@infradead.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, driverdevel <devel@driverdev.osuosl.org>, qat-linux@intel.com, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Linux Media Mailing List <linux-media@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, linaro-mm-sig@lis
List-Id: linux-nvdimm@lists.01.org

On Thu, Apr 25, 2019 at 05:55:23PM +0200, Arnd Bergmann wrote:
> On Thu, Apr 25, 2019 at 5:35 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > On Thu, Apr 25, 2019 at 12:21:53PM -0300, Mauro Carvalho Chehab wrote:
> >
> > > If I understand your patch description well, using compat_ptr_ioctl
> > > only works if the driver is not for s390, right?
> >
> > No; s390 is where "oh, just set ->compat_ioctl same as ->unlocked_ioctl
> > and be done with that; compat_ptr() is a no-op anyway" breaks.  IOW,
> > s390 is the reason for having compat_ptr_ioctl() in the first place;
> > that thing works on all biarch architectures, as long as all stuff
> > handled by ->ioctl() takes pointer to arch-independent object as
> > argument.  IOW,
> >         argument ignored => OK
> >         any arithmetical type => no go, compat_ptr() would bugger it
> >         pointer to int => OK
> >         pointer to string => OK
> >         pointer to u64 => OK
> >         pointer to struct {u64 addr; char s[11];} => OK
> 
> To be extra pedantic, the 'struct {u64 addr; char s[11];} '
> case is also broken on x86, because sizeof (obj) is smaller
> on i386, even though the location of the members are
> the same. i.e. you can copy_from_user() this, but not
> copy_to_user(), which overwrites 4 bytes after the end of
> the 20-byte user structure.

D'oh!  FWIW, it might be worth putting into Documentation/ somewhere;
basically, what is and what isn't biarch-neutral.

Or arch-neutral, for that matter - it's very close.  The only real
exception, IIRC, is an extra twist on m68k, where int behaves
like x86 long long - its alignment is only half its size, so
sizeof(struct {char c; int x;}) is 6, not 8 as everywhere
else.  Irrelevant for biarch, thankfully (until somebody gets insane
enough to implement 64bit coldfire, kernel port for it *and* biarch
support for m68k binaries on that thing, that is)...
