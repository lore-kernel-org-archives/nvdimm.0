Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com
 [IPv6:2a00:1450:4864:20::52c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9292B21B02822
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 05:54:35 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id f8-v6so10504602edt.13
 for <linux-nvdimm@lists.01.org>; Tue, 06 Nov 2018 05:54:35 -0800 (PST)
MIME-Version: 1.0
From: Fumiya Shigemitsu <shfy1014@gmail.com>
Date: Tue, 6 Nov 2018 22:54:22 +0900
Message-ID: <CALn6vpGtzt6KMRr1qnxB6xVzmBQT4VPoJQ7rm85thbrsJYP0Hw@mail.gmail.com>
Subject: [Question] About atomic operations on nvdimm in Linux kernel
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi all,

I have a question about atomic operations on nvdimm in Linux kernel.

We can use atomic operations in Linux kernel such as atomic_read(),
atomic_write() ...etc., but they don't handle the differences of
endianness. From my understanding, we should pay attention to them when
storing data to persistent disk. (e.g. metadata in filesystem such as ext4)

Maybe I can handle this problem by read/write lock, spinlock...etc.
However, atomic_* operations are useful, so I think that they should be in
Linux kernel for nvdimm. I suppose that this implementation is not
difficult, but there is no version of it as far as I know.

They are not just implemented or is there a reason that we don't need
them?

I'm sorry if there already was in the discussion or I have a wrong
understanding.

Regards,
Fumiya Shigemitsu.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
