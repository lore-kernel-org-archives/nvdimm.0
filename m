Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E4B62194D3AE
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 11:11:06 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id c206so20347465oib.0
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 11:11:06 -0800 (PST)
MIME-Version: 1.0
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
 <154180163107.70506.6894134402057805078.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4iKQW+zG1mS-vdbXuU1BE0bQ-zDJt1uQBo6EHkvMF5Y_Q@mail.gmail.com>
 <5c0d66c2-d628-54eb-b16e-8a6a8eb990c1@intel.com>
 <1543343054.3902.192.camel@linux.ibm.com>
In-Reply-To: <1543343054.3902.192.camel@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 27 Nov 2018 11:10:53 -0800
Message-ID: <CAPcyv4i5=tAx6=W44Vva7=0GO9A=j0w5vEEYMMv3NnC9_fMz6g@mail.gmail.com>
Subject: Re: [PATCH 01/11] keys-encrypted: add nvdimm key format type to
 encrypted keys
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
To: zohar@linux.ibm.com
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, keyrings@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 27, 2018 at 10:24 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> On Tue, 2018-11-27 at 09:20 -0700, Dave Jiang wrote:
> >
> > On 11/27/18 12:20 AM, Dan Williams wrote:
> > > On Fri, Nov 9, 2018 at 2:13 PM Dave Jiang <dave.jiang@intel.com> wrote:
> > >>
> > >> Adding nvdimm key format type to encrypted keys in order to limit the size
> > >
> > > s/Adding/Add an/
> > >
> > >> of the key to 32-bytes.
> > >>
> > >> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > >> ---
> > >>  security/keys/encrypted-keys/encrypted.c |   29 ++++++++++++++++++++---------
> > >>  1 file changed, 20 insertions(+), 9 deletions(-)
> > >>
> > >> diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
> > >> index d92cbf9687c3..182b4f136bdf 100644
> > >> --- a/security/keys/encrypted-keys/encrypted.c
> > >> +++ b/security/keys/encrypted-keys/encrypted.c
> > >> @@ -45,6 +45,7 @@ static const char hmac_alg[] = "hmac(sha256)";
> > >>  static const char blkcipher_alg[] = "cbc(aes)";
> > >>  static const char key_format_default[] = "default";
> > >>  static const char key_format_ecryptfs[] = "ecryptfs";
> > >> +static const char key_format_nvdimm[] = "nvdimm";
> > >>  static unsigned int ivsize;
> > >>  static int blksize;
> > >>
> > >> @@ -54,6 +55,7 @@ static int blksize;
> > >>  #define HASH_SIZE SHA256_DIGEST_SIZE
> > >>  #define MAX_DATA_SIZE 4096
> > >>  #define MIN_DATA_SIZE  20
> > >> +#define KEY_NVDIMM_PAYLOAD_LEN 32
> > >>
> > >>  static struct crypto_shash *hash_tfm;
> > >>
> > >> @@ -62,12 +64,13 @@ enum {
> > >>  };
> > >>
> > >>  enum {
> > >> -       Opt_error = -1, Opt_default, Opt_ecryptfs
> > >> +       Opt_error = -1, Opt_default, Opt_ecryptfs, Opt_nvdimm
> > >>  };
> > >>
> > >>  static const match_table_t key_format_tokens = {
> > >>         {Opt_default, "default"},
> > >>         {Opt_ecryptfs, "ecryptfs"},
> > >> +       {Opt_nvdimm, "nvdimm"},
> > >>         {Opt_error, NULL}
> > >>  };
> > >>
> > >> @@ -195,6 +198,7 @@ static int datablob_parse(char *datablob, const char **format,
> > >>         key_format = match_token(p, key_format_tokens, args);
> > >>         switch (key_format) {
> > >>         case Opt_ecryptfs:
> > >> +       case Opt_nvdimm:
> > >>         case Opt_default:
> > >>                 *format = p;
> > >>                 *master_desc = strsep(&datablob, " \t");
> > >> @@ -625,15 +629,22 @@ static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
> > >>         format_len = (!format) ? strlen(key_format_default) : strlen(format);
> > >>         decrypted_datalen = dlen;
> > >>         payload_datalen = decrypted_datalen;
> > >> -       if (format && !strcmp(format, key_format_ecryptfs)) {
> > >> -               if (dlen != ECRYPTFS_MAX_KEY_BYTES) {
> > >> -                       pr_err("encrypted_key: keylen for the ecryptfs format "
> > >> -                              "must be equal to %d bytes\n",
> > >> -                              ECRYPTFS_MAX_KEY_BYTES);
> > >> -                       return ERR_PTR(-EINVAL);
> > >> +       if (format) {
> > >> +               if (!strcmp(format, key_format_ecryptfs)) {
> > >> +                       if (dlen != ECRYPTFS_MAX_KEY_BYTES) {
> > >> +                               pr_err("encrypted_key: keylen for the ecryptfs format must be equal to %d bytes\n",
> > >> +                                       ECRYPTFS_MAX_KEY_BYTES);
> > >> +                               return ERR_PTR(-EINVAL);
> > >> +                       }
> > >> +                       decrypted_datalen = ECRYPTFS_MAX_KEY_BYTES;
> > >> +                       payload_datalen = sizeof(struct ecryptfs_auth_tok);
> > >> +               } else if (!strcmp(format, key_format_nvdimm)) {
> > >> +                       if (decrypted_datalen != KEY_NVDIMM_PAYLOAD_LEN) {
> > >> +                               pr_err("encrypted_key: nvdimm key payload incorrect length: %d\n",
> > >> +                                               decrypted_datalen);
> > >> +                               return ERR_PTR(-EINVAL);
> > >> +                       }
> > >
> > > I suspect this may not be the last key type that gets added, but I
> > > wonder if we should instead create key-types based on the dlen size.
> > > I.e. create a generic 32-byte key-type "enc32"? That way if another
> > > 32-byte requirement key comes along we don't need to come touch this
> > > routine again.
> > >
> >
> > I'm ok with that if Mimi is.
>
> If the usage (eg. format: ecryptfs, nvdimm) limits the dlen size(s),
> how will defining generic key-types help?  If there are no usage size
> limitations, then there would be no usage specific definition.
>
> I must be missing something.

...or I did a poor job of describing the problem. I'm just looking
ahead to another potential encrypted-key use case, but instead of
nvdimms this would be to lock / unlock persistent memory "namespace"
objects. If it turns out the namespace key is just another 32-byte
encrypted key should the encrypted-keys core grow support for a new
"namespace" key type, should it reuse the "nvdimm" key type, or should
we define a generic 32-byte payload-size-requirement key type?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
