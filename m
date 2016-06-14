Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Tue, 14 Jun 2016 11:41:31 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Message-ID: <20160614154131.GB25876@redhat.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4jdM1phR=kGoP2-7tfsVvbNe2C6hHNS5TD28ALGZQQTSw@mail.gmail.com>
 <1465861755.3504.185.camel@hpe.com>
 <x49fusf282h.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49fusf282h.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "agk@redhat.com" <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 14 2016 at  9:50am -0400,
Jeff Moyer <jmoyer@redhat.com> wrote:

> "Kani, Toshimitsu" <toshi.kani@hpe.com> writes:
> =

> >> I had dm-linear and md-raid0 support on my list of things to look at,
> >> did you have raid0 in your plans?
> >
> > Yes, I hope to extend further and raid0 is a good candidate. =A0=A0
> =

> dm-flakey would allow more xfstests test cases to run.  I'd say that's
> more important than linear or raid0.  ;-)

Regardless of which target(s) grow DAX support the most pressing initial
concern is getting the DM device stacking correct.  And verifying that
IO that cross pmem device boundaries are being properly split by DM
core (via drivers/md/dm.c:__split_and_process_non_flush()'s call to
max_io_len).

My hope is to nail down the DM core and its dependencies in block etc.
Doing so in terms of dm-linear doesn't seem like wasted effort
considering you told me it'd be useful to have for pmem devices.
 =

> Also, the next step in this work is to then decide how to determine on
> what numa node an LBA resides.  We had discussed this at a prior
> plumbers conference, and I think the consensus was to use xattrs.
> Toshi, do you also plan to do that work?

How does the associated NUMA node relate to this?  Does the
DM requests_queue need to be setup to only allocate from the NUMA node
the pmem device is attached to?  I recently added support for this to
DM.  But there will likely be some code need to propagate the NUMA node
id accordingly.

Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
