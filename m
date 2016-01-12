Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20160112013259.GC79247@tevye.fc.hp.com>
References: <cover.1452121277.git.jerry.hoemann@hpe.com>
	<CAPcyv4h_Oc3VVwtjp=+onSVq-Kuidd1r+9fbR-uo+DF_=e+jhg@mail.gmail.com>
	<CAPcyv4h+R4Aa7Zu3qWfmWwk6SWt22wuOowJvtpFhVUCdamTWDA@mail.gmail.com>
	<20160112013259.GC79247@tevye.fc.hp.com>
Date: Tue, 12 Jan 2016 10:55:16 -0800
Message-ID: <CAPcyv4ikzVM0uvDBpN=+A3+2v_SSvsD0GqP6PZ1S+8OUUhbK7A@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] nvdimm: Add an IOCTL pass thru for DSM calls
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, jmoyer <jmoyer@redhat.com>, Dmitry Krivenok <krivenok.dmitry@gmail.com>, Linda Knippers <linda.knippers@hpe.com>, Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>, Rafael J Wysocki <rafael.j.wysocki@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 11, 2016 at 5:32 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Sun, Jan 10, 2016 at 04:03:18PM -0800, Dan Williams wrote:
>> On Wed, Jan 6, 2016 at 3:58 PM, Dan Williams <dan.j.williams@intel.com>wrote:
[..]
>> 2/ Disallow potentially invalid calls to reach firmware.  At a minimum
>> the kernel needs to know the uuid in advance for any dsm it wants to
>> send.  I.e. check the 'dsm_fun_idx' against the dsm_mask.  This is
>> also important for making sure the kernel can manage exclusive access
>> to the configuration data area if present
>> (ND_CMD_{GET|SET}_CONFIG_DATA).
>
>   Technically, the kernel doesn't need to know the uuid in advance
>   as that is part of the bundle passed into the passthru.

True, but the set of uuids the kernel ever needs to know about is
likely small, and this policy mandates publication/notification of new
command sets to the kernel community.  Later on it gives the kernel a
touch point to implement dsm function number blacklisting which I
think is a useful security feature.

I'll leave the UUID parameter in the command in case a device ever
implements multiple command sets and we need to select between two
function number spaces.

>
>
>   Are you concerned about firmware mis-behaving when presented
>   with a (UUID, Function_Index) that is not supported?
>   (and really we should add Revision ID to that tuple.)
>
>   In a prior version of the patch not sent upstream, I did "discover" the
>   uuid and set up the dsm_mask.  However, this created a need to modify
>   kernel each time uuid changes.  Also, i don't think this is necessary
>   as FW should be gracefully validating its input arguments.  By
>   not setting up/using dsm_mask in pass thru case, this can be tested.

ACPICA will throw parse errors on mis-formatted DSMs.  We can't
prevent all malformed calls, but this is basic input validation that
the kernel can perform.

>   I don't understand the exclusive access concern w/ config data.
>   Could you please elaborate?

See nd_cmd_clear_to_send()... when a dimm is active the kernel
mandates that updates to the namespace labels go through sysfs.  This
is a safety measure to prevent userspace from inadvertently clobbering
in use labels.  Once the dimm goes idle (all 'region' devices related
to the dimm are disabled) userspace can manually update the
configuration data area.
