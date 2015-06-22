Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 22 Jun 2015 18:48:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/15] libnvdimm: support read-only btt backing devices
Message-ID: <20150622164804.GA9393@lst.de>
References: <CAPcyv4iAkSaCOzpJHJLLtJG_9M=5Jp75Kc9tVeCr__OjEB=ajQ@mail.gmail.com> <20150622063028.GA30434@lst.de> <CAPcyv4hmYiU5Gzmz8prPCESOYGn099-TffFTZH0E2OAx+JzkTQ@mail.gmail.com> <20150622072844.GA31263@lst.de> <CAPcyv4gUp6LtYVuzbQfzq6RbDyf=3nQ0509TPnNCJtVBazrUTg@mail.gmail.com> <x49pp4nwzun.fsf@segfault.boston.devel.redhat.com> <20150622154138.GC7952@lst.de> <x49ioafwx55.fsf@segfault.boston.devel.redhat.com> <20150622163224.GA9168@lst.de> <x49a8vrwv7f.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49a8vrwv7f.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 22, 2015 at 12:42:44PM -0400, Jeff Moyer wrote:
> OK, add torn sector detection/recovery to that statement, then.  More
> importantly, do you agree with the sentiment or not?

I think we're getting on a very slipper slope if we think about
application here.  Buffered I/O application must deal with torn
writes at any granulairty anyway, e.g. fsync + rename is the
only thing they can rely on right now (I actually have software O_ATOMIC
code to avoid this, but that's another story).

Direct I/O using application can make assumption if they know the sector
size, and we must have a way for them to be able to see our new
"subsector sector size".  And thos application are few inbetween but
also important so needing special cases for them is fine.  Although those
are the most likely ones to take advantage of byte addressing anyway.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
