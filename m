From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/8] device-dax: sub-division support
Date: Thu, 15 Dec 2016 18:33:50 -0800
Message-ID: <CAPcyv4h0t5aXV-6bf=tWdPKGS0oLkWrb0Z7-poMC+Nipp1kWTA@mail.gmail.com>
References: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x497f75hxwp.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hq=U8YkYqK4OE__FQyeGq2dKH+=14NttQu0M84yXZ7BQ@mail.gmail.com>
 <x494m278kam.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hzCHqF9ALYFYCpv=WyHoMOFDoeWOd38b4sKwmkkmSgLQ@mail.gmail.com>
 <x49shpp3zn8.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4gWW0NfiP6iGpaB5hAyiD8SMbeAfAKvezDLH1GzH_HqTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4gWW0NfiP6iGpaB5hAyiD8SMbeAfAKvezDLH1GzH_HqTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, Dec 15, 2016 at 3:48 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Dec 15, 2016 at 8:50 AM, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
[..]
> As for sub-division it was designed for the volatile case, I've heard
> feedback that some want it for the pmem case. You and I agree that
> it's *not* a good interface for the pmem case, so I'm fine disabling
> sub-division and telling them that they need to override a kernel
> default to use this mechanism for pmem, but otherwise say "just use
> libnvdimm namespace labels" for storage use cases.

So I went to go add support for making sub-division default off and
zero-size the initial device when sub-division is enabled. However, if
the policy is that the initial device is zero-sized for safety then,
for safety, we need to remember if the dax-region was *ever* in
dynamic mode to make sure that moving to dynamic mode is a one way
street.

If we're persisting the region setting then we might as well be
persisting the device-dax sub-division decisions. At that point we
might as well just wait for libnvdimm to grow namespace label support
for all NVDIMM types and let the provisioning happen at the level that
we agree is the right level for pmem.

Long story short, you're right, a volatile provisioning mechanism is
only tenable for volatile media. This enabling should wait until a
volatile consumer of device-dax surfaces, the dax_pmem driver should
never use it.
