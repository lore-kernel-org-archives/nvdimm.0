Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 23 Jun 2015 12:10:49 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/15] libnvdimm: support read-only btt backing devices
Message-ID: <20150623101049.GF24894@lst.de>
References: <CAPcyv4hmYiU5Gzmz8prPCESOYGn099-TffFTZH0E2OAx+JzkTQ@mail.gmail.com> <20150622072844.GA31263@lst.de> <CAPcyv4gUp6LtYVuzbQfzq6RbDyf=3nQ0509TPnNCJtVBazrUTg@mail.gmail.com> <x49pp4nwzun.fsf@segfault.boston.devel.redhat.com> <20150622154138.GC7952@lst.de> <x49ioafwx55.fsf@segfault.boston.devel.redhat.com> <20150622163224.GA9168@lst.de> <x49a8vrwv7f.fsf@segfault.boston.devel.redhat.com> <20150622164804.GA9393@lst.de> <x49fv5jvasv.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <x49fv5jvasv.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 22, 2015 at 02:48:48PM -0400, Jeff Moyer wrote:
> OK, so you think applications using buffered I/O will Just Work(TM)?  My
> guess is that things will start to break that hadn't broken in the
> past.  Sure, the application isn't designed properly, and that should be
> fixed, but we shouldn't foist this on users as the default.

They will work or break the same way as before.  We have all kinds of
cases of non-sector updates for buffered I/O anyway: inlіne data, tail
merging, etc.
