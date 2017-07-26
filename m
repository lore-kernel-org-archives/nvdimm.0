Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <1500552639-18523-1-git-send-email-sunqiuyang@huawei.com>
References: <1500552639-18523-1-git-send-email-sunqiuyang@huawei.com>
From: Dan Williams <dan.j.williams@gmail.com>
Date: Tue, 25 Jul 2017 17:15:10 -0700
Message-ID: <CAA9_cmeyVXgu1-ozb7b346ANq+P3e3ATWYfoVGkAKrn5cmo=Hw@mail.gmail.com>
Subject: Re: [PATCH v8 1/1] f2fs: dax: implement direct access
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
To: sunqiuyang <sunqiuyang@huawei.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net
List-ID: <linux-nvdimm@lists.01.org>

[ adding linux-nvdimm ]

On Thu, Jul 20, 2017 at 5:10 AM, sunqiuyang <sunqiuyang@huawei.com> wrote:
> From: Qiuyang Sun <sunqiuyang@huawei.com>
>
> This patch implements Direct Access (DAX) in F2FS, including:
>  - a mount option to choose whether to enable DAX or not

We're in the process of walking back and potentially deprecating the
use of the dax mount option for xfs and ext4 since dax can have
negative performance implications if page cache memory happens to be
faster than pmem. It should be limited to applications that
specifically want the semantic, not globally enabled for the entire
mount. xfs has went ahead and added the XFS_DIFLAG2_DAX indoe flag for
per-inode enabling of dax.

I'm wondering if any new filesystem that adds dax support at this
point should do so with inode flags and not a mount option?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
