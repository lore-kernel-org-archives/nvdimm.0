From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] acpi,
 nfit: skip ARS on machine-check-recovery capable platforms
Date: Wed, 08 Feb 2017 18:08:19 -0500
Message-ID: <x49poismgbg.fsf@segfault.boston.devel.redhat.com>
References: <148651103020.2605.2544850985469410207.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x4937fopvla.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hM2pz-sAcuXJTidfTMwA9sRVzCgwJjiw8ndtco8jmP=w@mail.gmail.com>
 <CAPcyv4hqrkro0X5vQ+21zU7R5iGirb1MU8J=nRRKvqDkDoKaxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hqrkro0X5vQ+21zU7R5iGirb1MU8J=nRRKvqDkDoKaxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 (Dan Williams's message of "Wed, 8 Feb 2017 15:01:53 -0800")
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:

> I was able to chat with Ashok and he warned that not all instructions
> that consume poison can generate a recovery point. So, thanks for
> prompting the double-check, we should definitely try to collect the
> badblocks list regardless of the machine check recovery capability of
> the system.

OK.  Thanks for looking into it!

-Jeff
