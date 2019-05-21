Return-Path: <owner-linux-mm@kvack.org>
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH v2] mm, memory-failure: clarify error message
Date: Tue, 21 May 2019 02:00:57 +0000
Message-ID: <20190521020057.GA8671@hori.linux.bs1.fc.nec.co.jp>
References: <1558403523-22079-1-git-send-email-jane.chu@oracle.com>
In-Reply-To: <1558403523-22079-1-git-send-email-jane.chu@oracle.com>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <3E17EDE90C0E1D4DA28CCC1CA00B2217@gisp.nec.co.jp>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Jane Chu <jane.chu@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 20, 2019 at 07:52:03PM -0600, Jane Chu wrote:
> Some user who install SIGBUS handler that does longjmp out
> therefore keeping the process alive is confused by the error
> message
>   "[188988.765862] Memory failure: 0x1840200: Killing
>    cellsrv:33395 due to hardware memory corruption"
> Slightly modify the error message to improve clarity.
>=20
> Signed-off-by: Jane Chu <jane.chu@oracle.com>

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks!=
