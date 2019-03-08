Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 7 Mar 2019 22:16:17 -0800
Message-ID: <CAPcyv4hwHpX-MkUEqxwdTj7wCCZCN4RV-L4jsnuwLGyL_UEG4A@mail.gmail.com>
Subject: Hang / zombie process from Xarray page-fault conversion (bisected)
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Barror, Robert" <robert.barror@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Willy,

We're seeing a case where RocksDB hangs and becomes defunct when
trying to kill the process. v4.19 succeeds and v4.20 fails. Robert was
able to bisect this to commit b15cd800682f "dax: Convert page fault
handlers to XArray".

I see some direct usage of xa_index and wonder if there are some more
pmd fixups to do?

Other thoughts?
