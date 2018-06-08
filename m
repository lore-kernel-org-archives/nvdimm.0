Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2AD9A210F4BD0
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 12:57:04 -0700 (PDT)
Subject: Re: [Qemu-devel] [qemu PATCH 2/5] acpi: "make check" should fail on
 asl mismatch
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
 <20180607223111.27792-2-ross.zwisler@linux.intel.com>
 <20180608020724-mutt-send-email-mst@kernel.org>
 <5352d2fb-9244-78b0-4f4b-2818359a4425@redhat.com>
 <20180608190040-mutt-send-email-mst@kernel.org>
 <CAFEAcA-h3xxeRFO32pnqrwR_wZ1=us-t0FunS2aJRpQV==3-GQ@mail.gmail.com>
 <20180608192148-mutt-send-email-mst@kernel.org>
 <74b8eaa6-841f-1e35-654f-ba0243970958@redhat.com>
 <20180608204402-mutt-send-email-mst@kernel.org>
From: Thomas Huth <thuth@redhat.com>
Message-ID: <1d0ae12d-7636-8f6e-dfde-8cc8697d38a1@redhat.com>
Date: Fri, 8 Jun 2018 21:56:58 +0200
MIME-Version: 1.0
In-Reply-To: <20180608204402-mutt-send-email-mst@kernel.org>
Content-Language: en-US
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 08.06.2018 20:41, Michael S. Tsirkin wrote:
> On Fri, Jun 08, 2018 at 07:23:06PM +0200, Thomas Huth wrote:
>> On 08.06.2018 18:24, Michael S. Tsirkin wrote:
>>> On Fri, Jun 08, 2018 at 05:16:30PM +0100, Peter Maydell wrote:
[...]
>>>> If there's a situation that shouldn't exist in the tree (ie
>>>> a bug), then make check should catch it, and result in a
>>>> failure, not just printing random stuff to stderr. Otherwise
>>>> I'm not going to notice it, whether I'm applying a pull request
>>>> or an individual patch.
>>>>
>>> It's ok if it happens, but it just makes debugging and reviewing
>>> ACPI patches a little bit harder until it's fixed.
>>
>> It's maybe ok for *you*, but this certainly confuses everybody else. If
>> I want to check my patches and suddenly some strange warnings are
>> popping up, I first assume that there is something wrong in my patches
>> (since I assume that the git repository is clean by default). So I've
>> got to waste my time debugging issues that are not my own. Thanks for
>> that :-/
> 
> Right so normally these do not pop out at all as I fix expected
> with a patch on top.

Apparently other people can also introduce changes that cause these
warnings. Anyway, I now "fixed" it here by uninstalling iasl, so never mind.

 Thomas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
