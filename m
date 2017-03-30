Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B500621DFA7BA
 for <linux-nvdimm@lists.01.org>; Thu, 30 Mar 2017 09:56:44 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id o67so37138272oib.1
 for <linux-nvdimm@lists.01.org>; Thu, 30 Mar 2017 09:56:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <58DD2D73.9040902@hpe.com>
References: <149067383236.19079.12786890634892425193.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49inmrua0c.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4i+q6iL9+fEUgL23Mb33Y7toCpXpeqh0rUgD+tcH3a2hg@mail.gmail.com>
 <x49r31fsunx.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jsJZih6t_hQ2Y3T8n0cGh79Kjf98WHfK0xoTVuifrTUQ@mail.gmail.com>
 <58DD2D73.9040902@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Mar 2017 09:56:43 -0700
Message-ID: <CAPcyv4j_bSSjP_a+DxPqnRcPT5WiaiiRQLUy0L5sUeSEXfrbEg@mail.gmail.com>
Subject: Re: [PATCH] test: add fio test for device-dax
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 30, 2017 at 9:08 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 03/29/2017 04:30 PM, Dan Williams wrote:
>> On Wed, Mar 29, 2017 at 1:19 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Dan Williams <dan.j.williams@intel.com> writes:
>>>
>>>> On Wed, Mar 29, 2017 at 1:02 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>>>> Dan Williams <dan.j.williams@intel.com> writes:
>>>>>
>>>>>> +check_min_kver()
>>>>>> +{
>>>>>> +     local ver="$1"
>>>>>> +     : "${KVER:=$(uname -r)}"
>>>>>> +
>>>>>> +     [ -n "$ver" ] || return 1
>>>>>> +     [[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
>>>>>> +}
>>>>>> +
>>>>>> +check_min_kver "4.11" || { echo "kernel $KVER may lack latest device-dax fixes"; exit $rc; }
>>>>>
>>>>> Can we stop with this kernel version checking, please?  Test to see if
>>>>> you can create a device dax instance.  If not, skip the test.  If so,
>>>>> and if you have a kernel that isn't fixed, so be it, you'll get
>>>>> failures.
>>>>
>>>> I'd rather not. It helps me keep track of what went in where. If you
>>>> want to run all the tests on a random kernel just do:
>>>>
>>>>     KVER="4.11.0" make check
>>>
>>> This, of course, breaks completely with distro kernels.
>>
>> Why does this break distro kernels? The KVER variable overrides "uname -r"
>
> FYI - dax-errors.sh doesn't look at KVER.
>

Patches welcome :).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
