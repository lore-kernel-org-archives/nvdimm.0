From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] acpi,
 nfit: skip ARS on machine-check-recovery capable platforms
Date: Wed, 8 Feb 2017 15:01:53 -0800
Message-ID: <CAPcyv4hqrkro0X5vQ+21zU7R5iGirb1MU8J=nRRKvqDkDoKaxQ@mail.gmail.com>
References: <148651103020.2605.2544850985469410207.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x4937fopvla.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hM2pz-sAcuXJTidfTMwA9sRVzCgwJjiw8ndtco8jmP=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hM2pz-sAcuXJTidfTMwA9sRVzCgwJjiw8ndtco8jmP=w@mail.gmail.com>
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
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Feb 8, 2017 at 9:42 AM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, Feb 8, 2017 at 7:10 AM, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:
>>
>>> If the platform supports machine-check-recovery then there is little
>>> reason to kick off opportunistic scrubs to collect a media error list.
>>> That initial scrub is only useful when it might prevent a kernel panic
>>> from consuming poison (a media error from memory).
>>
>> How expensive is the scrub?
>
> The ACPI spec is not clear, but it could range from benign to
> expensive and degrading system performance for 10's of minutes after
> boot
>
>> Even on platforms that support recoverable
>> machine checks, it's possible that you get one that is not recoverable.
>> You haven't sold me on this change.  ;-)
>>
>
> Adding Tony so he can either confirm, or point and laugh at my
> assumptions. In general you're right that there are machine check
> events that are not recoverable, but I'm thinking of problems like bus
> lockups and other disasters out of the direct cpu-to-memory data path.
> The question is whether should we avoid the cpu consuming media errors
> at all costs regardless of machine-check recovery. Tony might there be
> system-fatal gaps in memcpy_mcsafe() or userspace poison consumption
> handling that you would recommend aggressively trying to avoid media
> errors?
>

I was able to chat with Ashok and he warned that not all instructions
that consume poison can generate a recovery point. So, thanks for
prompting the double-check, we should definitely try to collect the
badblocks list regardless of the machine check recovery capability of
the system.
