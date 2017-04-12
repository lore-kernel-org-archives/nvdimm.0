Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6941F21A0483A
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 08:47:57 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id f22so36575895oib.2
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 08:47:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170412184602.006D.E1E9C6FF@jp.fujitsu.com>
References: <20170412184602.006D.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Apr 2017 08:47:55 -0700
Message-ID: <CAPcyv4iw-hsQjBPQ-Cj3XnOheQJCi3MezuxEm+KBjThB1ZS21Q@mail.gmail.com>
Subject: Re: Question about NVDIMM configuration
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 12, 2017 at 2:46 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> Hello,
>
> I'm studying NVDIMM specs and current Linux driver implementation now.
> But I'm really confused about it, and  I would like to ask a question here.
> So, I'm glad if anyone help me.
>
>
> My current question is ...
> "Which is correct scenario of user's operation? a) or b)?"
>
> a) NVDIMM user has to configure all of NVDIMM attributes (regions, namespaces,
>    interleave, and so on) via ndctl command.
>
> b) NVDIMM user has to configure the following things via firmware interface
>    (like BIOS menu) beforehand.
>     - regions (its size, place of NVDIMM, etc)
>     - interleaves
>    Then he/she boots the OS and configures only namespaces via ndctl.
>
> In my uderstanding, NVDIMM driver has to read NFIT tables at boot time, and
> read many information (like block window apertures, interleave information,
> and so on). To read NFIT at boot time, its configuration must be set before
> system boot. So, I feel that b) is natural.
>
> However, ndctl command has the feature that user can change the type of
> namespace (pmem or blk). In addition, user can set size of namespace.
>
> Then I suppose that NFIT table must be changed
> when user changed the above attributes of NVDIMM via ndctl to reconfigure
> NVDIMM, and NVDIMM drivers has to check _FIT method and read changed NFIT
> again.
> If this is correct, I think that not only namespace, but also all of
> attributes of NVDIMM should be configured via ndctl. So, a) looks correct.....
>
> I'm not sure which is correct, and I don't have real NVDIMM server to confirm it.
> So, please answer my question.

Hi,

The answer is that BIOS and vendor specific commands set the region
sizes. Changing the region boundaries requires a reboot because it
changes memory controller register settings. Once the regions are
specified the NFIT will be static each boot. The ndctl command can
then create namespaces out of regions. If the the platform allows
aliasing DIMM capacity between the blk and pmem access modes then a
namespace configuration can pick how much capacity is accessible
between each access mode. Creating and changing namespaces does not
require reboots because no memory controller settings are being
changed, it only requires writing labels to the DIMMs.  Some DIMMs do
not support labels, and in that case the size of the namespace is
static and identical to the size of the region.  In that static /
no-label case ndctl can still be used to changed the mode of the
namespace. For example it can place the namespace in "sector" mode
with the "btt" driver.

Hope this helps.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
