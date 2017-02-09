From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] acpi, nfit: skip ARS on machine-check-recovery capable
 platforms
Date: Thu, 9 Feb 2017 17:20:56 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3A2B11EA@ORSMSX114.amr.corp.intel.com>
References: <148651103020.2605.2544850985469410207.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x4937fopvla.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hM2pz-sAcuXJTidfTMwA9sRVzCgwJjiw8ndtco8jmP=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hM2pz-sAcuXJTidfTMwA9sRVzCgwJjiw8ndtco8jmP=w@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Williams, Dan J" <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

> Adding Tony so he can either confirm, or point and laugh at my
> assumptions. In general you're right that there are machine check
> events that are not recoverable, but I'm thinking of problems like bus
> lockups and other disasters out of the direct cpu-to-memory data path.
> The question is whether should we avoid the cpu consuming media errors
> at all costs regardless of machine-check recovery. Tony might there be
> system-fatal gaps in memcpy_mcsafe() or userspace poison consumption
> handling that you would recommend aggressively trying to avoid media
> errors?

TL;DR - I think it is worth it ... but I worry more about errors than most
people.

In current generation systems the two most common sources of machine
checks are memory, and I/O.  They dwarf all the others like cache and
bus lockups.  So it is worth trying to avoid memory issues.

Whether you can recover from a machine check triggered from a CPU
read of memory depends on which instructions you use, and the alignment
of the access. That's why memcpy_mcsafe() will start with a few byte reads
if needed to align the source address while other copy routines prefer to
align the destination ... memory writes that straddle cache lines are more
expensive than reads that do that ... but the point of the routine is to be
safe, so we drop a tiny amount of performance in the unaligned case to
make sure we will be able to recover.

We can't control how userspace will access memory ... so if we can find
the errors before they stumble into them it is a win.

-Tony
