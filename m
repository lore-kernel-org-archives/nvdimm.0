Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9165022620E98
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 17:57:01 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id 126-v6so6942092oig.0
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 17:57:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA9_cmftDhE4dbEAPSXhW2DY2j_toWmsU2E-NJ6cG3Vd0MdXVw@mail.gmail.com>
References: <20180215210932.15490-1-erik.schmauss@intel.com>
 <20180215210932.15490-6-erik.schmauss@intel.com>
 <CAA9_cmftDhE4dbEAPSXhW2DY2j_toWmsU2E-NJ6cG3Vd0MdXVw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Apr 2018 17:56:59 -0700
Message-ID: <CAPcyv4hp_pm2n3H_froFkedd_GMQvsrEc8yZxYzfYkPDYvjDww@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] ACPICA: Integrate package handling with
 module-level code
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
To: "Schmauss, Erik" <erik.schmauss@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Bob Moore <robert.moore@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 12, 2018 at 3:50 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> [ adding linux-nvdimm ]
>
> On Fri, Feb 16, 2018 at 7:20 AM Erik Schmauss <erik.schmauss@intel.com>
> wrote:
>
>> ACPICA commit 8faf6fca445eb7219963d80543fb802302a7a8c7
>
>> This change completes the integration of the recent changes to
>> package object handling with the module-level code support.
>
>> For acpi_exec, the -ep flag is removed.
>
>> This change allows table load to behave as if it were a method
>> invocation. Before this, the definition block definition below would
>> have loaded all named objects at the root scope. After loading, it
>> would execute the if statements at the root scope.
>
>> DefinitionBlock (...)
>> {
>>    Name(OBJ1, 0)
>
>>    if (1)
>>    {
>>      Device (DEV1)
>>      {
>>        Name (_HID,0x0)
>>      }
>>    }
>>    Scope (DEV1)
>>    {
>>      Name (OBJ2)
>>    }
>> }
>
>> The above code would load OBJ1 to the namespace, defer the execution
>> of the if statement and attempt to add OBJ2 within the scope of DEV1.
>> Since DEV1 is not in scope, this would incur an AE_NOT_FOUND error.
>> After this error is emitted, the if block is invoked and DEV1 and its
>> _HID is added to the namespace.
>
>> This commit changes the behavior to execute the if block in place
>> rather than deferring it until all tables are loaded. The new
>> behavior is as follows: insert OBJ1 in the namespace, invoke the if
>> statement and add DEV1 and its _HID to the namespace, add OBJ2 to the
>> scope of DEV1.
>
>> Bug report links:
>> Link: https://bugs.acpica.org/show_bug.cgi?id=963
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=153541
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=196165
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=192621
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=197207
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=198051
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=198515
>
>> ACPICA repo:
>> Link: https://github.com/acpica/acpica/commit/8faf6fca
>
>> Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> Signed-off-by: Bob Moore <robert.moore@intel.com>
>> Signed-off-by: Erik Schmauss <erik.schmauss@intel.com>
>
> Hi,
>
> This commit 5a8361f7ecce ("ACPICA: Integrate package handling with
> module-level code") regresses the detection of persistent memory in my
> qemu-kvm setup.
>

With the following set of clean reverts on top of latest-Linus I'm
back to a working configuration:

 Revert "ACPICA: Change a compile-time option to a runtime option"
 Revert "ACPICA: Cleanup/simplify module-level code support"
 Revert "ACPICA: Rename a global for clarity, no functional change"
 Revert "ACPICA: Add option to disable Package object name resolution errors"
 Revert "ACPICA: Integrate package handling with module-level code"

...i.e.

git revert 34f206fd757c
git revert a406dea82af8
git revert e7d970f6fca8
git revert 959c38a7e128
git revert 5a8361f7ecce
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
