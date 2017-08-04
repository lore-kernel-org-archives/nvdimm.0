Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8FAF621D2DCE6
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 08:08:04 -0700 (PDT)
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC 01/16] NOVA: Documentation
Date: Fri, 4 Aug 2017 15:09:49 +0000
Message-ID: <1501859388.2757.1.camel@wdc.com>
References: <150174646416.104003.14042713459553361884.stgit@hn>
 <150174649708.104003.4595004262958377346.stgit@hn>
In-Reply-To: <150174649708.104003.4595004262958377346.stgit@hn>
Content-Language: en-US
Content-ID: <581854719780B94A9B82DBA986255F00@namprd04.prod.outlook.com>
MIME-Version: 1.0
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
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "swanson@eng.ucsd.edu" <swanson@eng.ucsd.edu>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: "steven.swanson@gmail.com" <steven.swanson@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2017-08-03 at 00:48 -0700, Steven Swanson wrote:
> +### DAX Support
> +
> +Supporting DAX efficiently is a core feature of NOVA and one of the challenges
> +in designing NOVA is reconciling DAX support which aims to avoid file system
> +intervention when file data changes, and other features that require such
> +intervention.
> +
> +NOVA's philosophy with respect to DAX is that when a program uses DAX mmap to
> +to modify a file, the program must take full responsibility for that data and
> +NOVA must ensure that the memory will behave as expected.  At other times, the
> +file system provides protection.  This approach has several implications:
> +
> +1. Implementing `msync()` in user space works fine.
> +
> +2. While a file is mmap'd, it is not protected by NOVA's RAID-style parity
> +mechanism, because protecting it would be too expensive.  When the file is
> +unmapped and/or during file system recovery, protection is restored.
> +
> +3. The snapshot mechanism must be careful about the order in which in adds
> +pages to the file's snapshot image.

Hello Steven,

Thank you for having shared this very interesting work. After having read the
NOVA paper and patch 01/16 I have a question for you. Does the above mean that
COW is disabled for writable mmap-ed files? If so, what is the reason behind
this? Is there a fundamental issue that does not allow to implement COW for
writable mmap-ed files? Or have you perhaps tried to implement this and was the
performance not sufficient? Please note that I'm neither a filesystem nor a
persistent memory expert.

Thanks,

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
